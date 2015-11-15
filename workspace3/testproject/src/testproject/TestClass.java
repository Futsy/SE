package testproject;

import com.sun.javafx.css.Declaration;

public class TestClass {
	
	public TestClass() {}
	
	/**
	 * 
	 * 
	 * Complexity
	 * 
	 * 
	 */
	public int CalculateComplexity(int tree)
	{
		int returnList;

		switch (tree) {
		case Declaration dec : method(_, _, _, _, Statement impl):
			returnList += <Complexity(dec), size(LinesOfCode({impl@src}))>;
		case Declaration dec : constructor(_, _, _, Statement impl): 
			returnList += <Complexity(dec), size(LinesOfCode({impl@src}))>;
		}

		return returnList;
	}

	/**
	 * Calculate the complexity for a given declaration
	 */
	public int Complexity(Declaration declaration) 
	{
		int complexity = 1;
		
		// Check every statement that creates a branch
		switch (declaration) {
		case \if(_, _):			complexity += 1;
		case \if(_, _, _):		complexity += 1;
		case \for(_, _, _):		complexity += 1;
		case \for(_, _, _, _):	complexity += 1;
		case \foreach(_, _, _):	complexity += 1;
		case \do(_, _):			complexity += 1;
		case \while(_, _):		complexity += 1;
		case \catch(_, _):		complexity += 1;
		case \case(_):			complexity += 1;
		
		// All the expressions
		case conditional(_,_,_): complexity += 1;
		case \infix(_, "||", _): complexity += 1;
	    case \infix(_, "&&", _): complexity += 1;
		}
		
		return complexity;
	}
	
	
	
	
	
	
	
	
	
	/**
	 * 
	 * 
	 * Coupling
	 * 
	 * 
	 */
	
	
	
	/** 
	 * Generate a coupling metric by calculating the how many if the method calls to classes
	 * which are part of the project, are calls to interfaces and how many are calls to 
	 * concrete classes
	 */
	public int coupling(int model)
	{
		int localMethodCalls = getAllLocalMethodCalls(model);
		
		// Filter out all local method calls to interfaces
		// Note that the all construct should not be funcitonally necessary as domain should always return a singleton list
		// (a method cannot be part of multiple classes)
		int callsToInterface = [method | method <- localMethodCalls, all( 
			containingClass <- domain(rangeR(model@containment, {method})), 
			containingClass.scheme == "java+interface")
		]; 
		
		// If we don't have any method calls, we have pretty loose coupling
		if(isEmpty(localMethodCalls)) 
			return 100;
		
		// If we don't have any method calls to interfaces, we have pretty tight coupling
		if(isEmpty(callsToInterface)) 
			return 0;
		
		return toReal(size(callsToInterface)) / toReal(size(localMethodCalls));
	}

	/**
	 * Return all the methods
	 */
	private int getAllLocalMethodCalls(int model)
	{
		// Get all the method calls from the project
		int methodCalls = [m.to | m <-model@methodInvocation];
		
		// Get all the methods defined in the project
		int methodsInProject = [ e | e <- model@containment.to, e.scheme == "java+method"];
		
		// The intersection of both are the method calls to methods local to the project
		// Note that we do not use sets as we want to keep multiples
		return methodCalls & methodsInProject;
	}
	
	
	
	
	/**
	 * 
	 * 
	 * Duplication
	 * 
	 * 
	 */

	/**
	 * Calculates the duplication in a project
	 */
	public int CalculateDuplication(int l)
	{
		// We get a map of file to the lines in that file. 
		// In order to be able to uniquely define lines later on, we need the combination
		// <loc,line number>
		// so map[loc, lrel[loc, int, str]] 
		int lines = 10; //(k : [<k, I, l[k][I]> | I <- [0..size(l[k])]] | k <- l);
		
		// Now we create a list of blocks of 6 subsequent lines in all files. 
		// As a group of 6 lines that appears (without alterations) in more than one place is a duplicate
		int allBlocksOf6 = [*[take(6, lines[k][block..]) | block <- [0..size(lines[k]) - 6]] | k <- lines];
		
		// Use the getDuplicates function to get all 6 line blocks which occur multiple times in the input
		// we only check the str part of the lines in the blocks.
		int duplicates = getDuplicates(allBlocksOf6);	
		
		// We now have a list of duplicate blocks. We flatten it to make a set of <file, line number> tuples
		// to get all unique duplicate lines
		return size({ *[ <f, li> | <f,li,_> <- block] | block <- duplicates });
		return 10;
	}
	
	/**
	 * Filter a list of lrel[int, str] and return only the elements
	 * of which the str part occurs multiple times in the list
	 */
	int getDuplicates(int  l)
	{
		if(isEmpty(l)) 
			return [];
		
		int  duplicates = {};
		
		for(I <- [0..size(l)-1])
		{
			int Head = l[I];
			int Tail = l[I+1..];
			
			int dupes = { x | x <- Tail, x.c == Head.c};
			if(!isEmpty(dupes))
				duplicates += {Head} + dupes;
		}
		return duplicates;
	}
	
	
	/**
	 * 
	 * 
	 * Main
	 * 
	 * 
	 */
	
	
	/**
	 * Method that calculates all the metrices for a given project
	 */
	public void AnalyseProject(int project, int duplication) 
	{
		println("-- Creation ----------------");
		
		// Create the model
		int model = createM3FromEclipseProject(project);
		println(" - Created model");
		
		// To compute volume we take all that code and count everything 
		// except for empty lines and comments
		int locToSloc = LinesOfCodePerFile(files(model));
		int sloc = 1;//[*locToSloc[f] | f <- locToSloc];
		println(" - Calculated Lines of code <size(sloc)>");
		
		int ast = { createAstFromFile(f, false) | f <- files(model)};
		println(" - Created AST");
		
		// So now we get the complexity and sloc per method
		int complexity = CalculateComplexity(ast);
		println(" - Calculated complexity");
	
		// Duplication
		int duplications = -1;
		if (duplication) {
			duplications = CalculateDuplication(locToSloc);
			println(" - Calculated duplication <duplications>\n\n");
		}
		
		// Show all the results
		Report(size(sloc), complexity, duplications);
	}
	
	/**
	 * Method that outputs all the metrics which are required by the assignment
	 */
	public void Report(int sloc, int complexity, int duplications) 
	{
		println("-- Report ------------------");
		
		println("Metrics");
		int volumeClass      = ReportVolume(sloc);
		int unitSizeClass    = ReportUnitSize(complexity);
		int complexityClass  = ReportComplexity(sloc, complexity);
		
		// Calculate SIG Model
		int analysability = -1;
		int changeability = -1;
		int stability	  = -1;
		int testability   = -1;
		
		if (duplications != -1) {
			duplicationClass = ReportDuplications(sloc, duplications);
			
			analysability = round(toReal(volumeClass + duplicationClass + unitSizeClass) / 3);
			changeability = round(toReal(complexityClass + duplicationClass) / 2);
			testability   = round(toReal(complexityClass + unitSizeClass) / 2);
		}
		else {
			analysability = round(toReal(volumeClass + unitSizeClass) / 2);
			changeability = complexityClass;
			testability   = round(toReal(complexityClass + unitSizeClass) / 2);
		}
		
		println("Maintainability");
		ReportMaintainability(analysability, changeability, stability, testability);
	}
	
	/**
	 * Method that prints the volume metric
	 */
	public int ReportVolume(int sloc)
	{
	 	int class1 = 0;
	 	
	 	if (sloc < 66000) {
	 		class1 = 4;
	 	}
	 	else if (sloc < 246000) {
	 		class1 = 3;
	 	}
	 	else if (sloc < 665000) {
	 		class1 = 2;
	 	}
	 	else if (sloc < 1310000) {
	 		class1 = 1;
	 	}
	 	
	 	println(" Volume:");
	 	println("   Classification: <ClassToStr(class)>"); 
	 	println("   <sloc> source lines of code");
	 	return class1;
	}
	
	/**
	 * Method that prints the Complexity per unit
	 */
	public int ReportUnitSize(int complexity)
	{
		if (size(complexity) == 0)
			throw "Empty list";
			
		int slocModerate = 0;
		int slocHigh     = 0;
		int slocVeryHigh = 0;
		int slocMethods  = 0;
	 	
	 	// Calculate the complexity
	 	for (int meth <- complexity) {
	 		slocMethods += meth.methodSloc;
	 		
	 		if (meth.methodSloc > 100) {
	 			slocVeryHigh += meth.methodSloc;
	 		}
	 		else if (meth.methodSloc > 50) {
	 			slocHigh += meth.methodSloc;
	 		}
	 		else if (meth.methodSloc > 20) {
	 			slocModerate += meth.methodSloc;
	 		}
	 	}
	 	
	 	if (slocMethods == 0)
	 		throw "No SLOC in methods";
	 	
	 	// Classification for the system
	 	int class1 = 0;
		
	 	int percentageModerate = toReal(slocModerate) / slocMethods * 100;
	 	int percentageHigh     = toReal(slocHigh) / slocMethods * 100;
	 	int percentageVeryHigh = toReal(slocVeryHigh) / slocMethods * 100; 
	 	
	 	if (percentageModerate <= 25 && percentageHigh == 0 && percentageVeryHigh == 0) {
	 		class1 = 4;
	 	}
	 	else if (percentageModerate <= 30 && percentageHigh <= 5 && percentageVeryHigh == 0) {
	 		class1 = 3;
	 	}
	 	else if (percentageModerate <= 40 && percentageHigh <= 10 && percentageVeryHigh == 0) {
	 		class1 = 2;
	 	}
	 	else if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
	 		class1 = 1;
	 	}
	
		println( " Unit size:");
	 	println("   Classification: <ClassToStr(class)>");
	 	println("   Moderate : <percentageModerate> %,");
	 	println("   High     : <percentageHigh> %,");
	 	println("   Very High: <percentageVeryHigh> %,");
	 	return class1;
	}
	
	/**
	 * Method that prints the Complexity per unit
	 */
	public int ReportComplexity(int sloc, int complexity)
	{
	 	if (sloc <= 0)
			throw "\<=0 as input";
			
		if (size(complexity) == 0)
			throw "Empty list";
			
		int slocModerate = 0;
		int slocHigh     = 0;
		int slocVeryHigh = 0;
	 	
	 	// Calculate the complexity
	 	for (int meth <- complexity) {
	 		if (meth.complexity > 50) {
	 			slocVeryHigh += meth.methodSloc;
	 		}
	 		else if (meth.complexity > 20) {
	 			slocHigh += meth.methodSloc;
	 		}
	 		else if (meth.complexity > 10) {
	 			slocModerate += meth.methodSloc;
	 		}
	 	}
	 	
	 	// Classification for the system
	 	int class1 = 0;
	 	
	 	// Calculate percentage of SLOC of total
	 	/*\warning: The paper mentions: 
	 		For example, if, in a 10.000 LOC system, the high risk units together amount to
			500 LOC, then the aggregate number we compute for that risk category is 5%
			
			NOT over the SLOC from methods
		*/
	 	int percentageModerate = toReal(slocModerate) / sloc * 100;
	 	int percentageHigh     = toReal(slocHigh) / sloc * 100;
	 	int percentageVeryHigh = toReal(slocVeryHigh) / sloc * 100; 
	 	
	 	if (percentageModerate <= 25 && percentageHigh == 0 && percentageVeryHigh == 0) {
	 		class1 = 4;
	 	}
	 	else if (percentageModerate <= 30 && percentageHigh <= 5 && percentageVeryHigh == 0) {
	 		class1 = 3;
	 	}
	 	else if (percentageModerate <= 40 && percentageHigh <= 10 && percentageVeryHigh == 0) {
	 		class1 = 2;
	 	}
	 	else if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
	 		class1 = 1;
	 	}
	 	
	 	println( " Unit complexity:");
	 	println("   Classification: <ClassToStr(class)>");
	 	println("   Moderate : <percentageModerate> %,");
	 	println("   High     : <percentageHigh> %,");
	 	println("   Very High: <percentageVeryHigh> %,");
	 	return class1;
	 }
	 
	/**
	 * Method that prints the duplications metric
	 */
	public int ReportDuplications(int sloc, int duplications)
	{
		if (sloc <= 0 || duplications <= 0)
			throw "\<=0 as input";
			
		percentageDupes = toReal(duplications) / sloc * 100;
		
		int class1 = 0;
		if (percentageDupes <= 3) {
			class1 = 4;
		}
		else if (percentageDupes <= 5) {
			class1 = 3;
		}
		else if (percentageDupes <= 10) {
			class1 = 2;
		}
		else if (percentageDupes <= 20) {
			class1 = 1;
		}
		
		println(" Duplications:");
		println("   Classification: <ClassToStr(class)>");
		println("   Duplicates make up atleast <percentageDupes> % of the total code");
		return class1;
	}
	
	/**
	 * Converts an integer to a classification string
	 */
	public String ClassToStr(int class1) 
	{
		switch (class1) {
		case 4:	return "++";
		case 3: return "+";
		case 2: return "o";
		case 1: return "-";
		case 0: return "--";
		default: return "untested";
		}
	}
	
	/**
	 * Reports the SIG Model 
	 */
	public void ReportMaintainability(int analysability, int changeability, int stability, int testability)
	{
		println("  analysability: " + ClassToStr(analysability));
		println("  changeability: " + ClassToStr(changeability));
		println("      stability: " + ClassToStr(stability));
		println("    testability: " + ClassToStr(testability));
		println("         overal: " + ClassToStr((analysability + changeability + testability) / 3));
	}

	
	
	/**
	 * 
	 * 
	 * Volume
	 * 
	 * 
	 */
	
	
	
	
	
	/**
	 * Get the total source lines of code in the parts
	 */
	public int LinesOfCode(int parts)
	{
		// Get the lines per file and splice all lines to a single list
		int locToSloc = LinesOfCodePerFile(parts);
		return 10;//[*locToSloc[f] | f <- locToSloc];
	} 
	
	/**
	 * Get the SLOC for a specific file
	 */
	public int LinesOfCodePerFile(int parts) 
	{
		int fileToLines = 1;
		
		for (part <- parts) {
			fileToLines[part] = RemoveMultiLineComments(RemoveSingleLineComments(part));
		}
		return fileToLines;
	}
	
	/**
	 * Removes all the // comments
	 */
	public int RemoveSingleLineComments(int part)
	{
		int linesInFile = 10;
		for (String line : readFileLines(part)) {	
			// Remove all string literal content
			int line = RemoveQuotes(line);			
			
			// Remove all the single line comments
			int takeItFrom = findFirst(line, "//");
			
			int fixedString = takeItFrom == -1 ? line : line;
			if (isEmpty(fixedString)) 
				continue;
			linesInFile += trim(fixedString);
		}
		return linesInFile;
	}
	
	/**
	 * Removes all the /* to \*\/ comments
	 */
	public int RemoveMultiLineComments(int input)
	{
		int lines = 10;
		bool started = false;
	
		for (line <- input) {
			actualLine = line;
			
			if (started) {
				endPoint = findFirst(line, "*/");
				if (endPoint >= 0) {
					started = false;
					actualLine = actualLine[endPoint + 2..];
				}
				else {
					continue;
				}
			}
			
			// Check for single line multiline comments
			while (true) {
				startPoint = findFirst(actualLine, "/*");
				endPoint = findFirst(actualLine, "*/");
				
				if (startPoint >= 0 && endPoint >= 0) {
					// start and end on this line
					actualLine = actualLine[..startPoint] + actualLine[endPoint + 2..];
				}
				else if (startPoint >= 0) {
					// start on this line
					started = true;
					if (!isEmpty(trim(actualLine[..startPoint])))
						lines += trim(actualLine[..startPoint]);
					break;
				}
				else {
					if (!isEmpty(actualLine))
						lines += trim(actualLine);
					break;
				}
			}
		}
		return lines;
	}
	
	/**
	 * This function replaces string literal comments with another placeholder
	 */
	public String RemoveQuotes(String line)
		{ switch(line) { case /<s:\"([^\"\\]|\\.)*\">/ => replaceAll(replaceAll(replaceAll(s, "/*", "~`"), "*/", "±§"), "\/\/", "`§") }; }
}
