module main

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import util::Math;

// Cool graphic things
import vis::Figure;
import vis::Render;

// Functions outside this file for analysis
import volume;
import complexity;
import duplication;

// locations of projects for convenience (could just enter a path)
public loc testProject  = |project://testproject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;

/**
 * Method that calculates all the metrices for a given project
 */
public void AnalyseProject(loc project, bool duplication) 
{
	println("-- Creation ----------------");
	
	// Create the model
	model = createM3FromEclipseProject(project);
	println(" - Created model");
	
	// To compute volume we take all that code and count everything 
	// except for empty lines and comments
	locToSloc = LinesOfCodePerFile(files(model));
	sloc = [*locToSloc[f] | f <- locToSloc];
	println(" - Calculated Lines of code <size(sloc)>");
	
	ast = { createAstFromFile(f, false) | f <- files(model)};
	println(" - Created AST");
	
	// So now we get the complexity and sloc per method
	complexity = CalculateComplexity(ast);
	println(" - Calculated complexity");

	// Duplication
	duplications = -1;
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
public void Report(int sloc, lrel[int, int] complexity, int duplications) 
{
	println("-- Report ------------------");
	
	println("Metrics");
	volumeClass      = ReportVolume(sloc);
	unitSizeClass    = ReportUnitSize(complexity);
	complexityClass  = ReportComplexity(sloc, complexity);
	
	// Calculate SIG Model
	analysability = -1;
	changeability = -1;
	stability	  = -1;
	testability   = -1;
	
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
 	int class = 0;
 	
 	if (sloc < 66000) {
 		class = 4;
 	}
 	else if (sloc < 246000) {
 		class = 3;
 	}
 	else if (sloc < 665000) {
 		class = 2;
 	}
 	else if (sloc < 1310000) {
 		class = 1;
 	}
 	
 	println(" Volume:");
 	println("   Classification: <ClassToStr(class)>"); 
 	println("   <sloc> source lines of code");
 	return class;
}

/**
 * Method that prints the Complexity per unit
 */
public int ReportUnitSize(lrel[int, int] complexity)
{
	if (size(complexity) == 0)
		throw "Empty list";
		
	slocModerate = 0;
 	slocHigh     = 0;
 	slocVeryHigh = 0;
 	slocMethods  = 0;
 	
 	// Calculate the complexity
 	for (tuple[int complexity, int methodSloc] meth <- complexity) {
 		slocMethods += meth.methodSloc;
 		
 		if (meth.methodSloc > 200) {
 			slocVeryHigh += meth.methodSloc;
 		}
 		else if (meth.methodSloc > 100) {
 			slocHigh += meth.methodSloc;
 		}
 		else if (meth.methodSloc > 50) {
 			slocModerate += meth.methodSloc;
 		}
 	}
 	
 	if (slocMethods == 0)
 		throw "No SLOC in methods";
 	
 	// Classification for the system
 	int class = 0;
	
	percentageModerate = toReal(slocModerate) / slocMethods * 100;
 	percentageHigh     = toReal(slocHigh) / slocMethods * 100;
 	percentageVeryHigh = toReal(slocVeryHigh) / slocMethods * 100; 
 	
 	if (percentageModerate <= 25 && percentageHigh == 0 && percentageVeryHigh == 0) {
 		class = 4;
 	}
 	else if (percentageModerate <= 30 && percentageHigh <= 5 && percentageVeryHigh == 0) {
 		class = 3;
 	}
 	else if (percentageModerate <= 40 && percentageHigh <= 10 && percentageVeryHigh == 0) {
 		class = 2;
 	}
 	else if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
 		class = 1;
 	}

	println( " Unit size:");
 	println("   Classification: <ClassToStr(class)>");
 	println("   Moderate : <percentageModerate> %,");
 	println("   High     : <percentageHigh> %,");
 	println("   Very High: <percentageVeryHigh> %,");
 	return class;
}

/**
 * Method that prints the Complexity per unit
 */
public int ReportComplexity(int sloc, lrel[int, int] complexity)
{
 	if (sloc <= 0)
		throw "\<=0 as input";
		
	if (size(complexity) == 0)
		throw "Empty list";
		
 	slocModerate = 0;
 	slocHigh     = 0;
 	slocVeryHigh = 0;
 	
 	// Calculate the complexity
 	for (tuple[int complexity, int methodSloc] meth <- complexity) {
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
 	int class = 0;
 	
 	// Calculate percentage of SLOC of total
 	/*\warning: The paper mentions: 
 		For example, if, in a 10.000 LOC system, the high risk units together amount to
		500 LOC, then the aggregate number we compute for that risk category is 5%
		
		NOT over the SLOC from methods
	*/
 	percentageModerate = toReal(slocModerate) / sloc * 100;
 	percentageHigh     = toReal(slocHigh) / sloc * 100;
 	percentageVeryHigh = toReal(slocVeryHigh) / sloc * 100; 
 	
 	if (percentageModerate <= 25 && percentageHigh == 0 && percentageVeryHigh == 0) {
 		class = 4;
 	}
 	else if (percentageModerate <= 30 && percentageHigh <= 5 && percentageVeryHigh == 0) {
 		class = 3;
 	}
 	else if (percentageModerate <= 40 && percentageHigh <= 10 && percentageVeryHigh == 0) {
 		class = 2;
 	}
 	else if (percentageModerate <= 50 && percentageHigh <= 15 && percentageVeryHigh <= 5) {
 		class = 1;
 	}
 	
 	println( " Unit complexity:");
 	println("   Classification: <ClassToStr(class)>");
 	println("   Moderate : <percentageModerate> %,");
 	println("   High     : <percentageHigh> %,");
 	println("   Very High: <percentageVeryHigh> %,");
 	return class;
 }
 
/**
 * Method that prints the duplications metric
 */
public int ReportDuplications(int sloc, int duplications)
{
	if (sloc <= 0 || duplications <= 0)
		throw "\<=0 as input";
		
	percentageDupes = toReal(duplications) / sloc * 100;
	
	int class = 0;
	if (percentageDupes <= 3) {
		class = 4;
	}
	else if (percentageDupes <= 5) {
		class = 3;
	}
	else if (percentageDupes <= 10) {
		class = 2;
	}
	else if (percentageDupes <= 20) {
		class = 1;
	}
	
	println(" Duplications:");
	println("   Classification: <ClassToStr(class)>");
	println("   Duplicates make up atleast <percentageDupes> % of the total code");
	return class;
}

/**
 * Converts an integer to a classification string
 */
public str ClassToStr(int class) 
{
	switch (class) {
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
