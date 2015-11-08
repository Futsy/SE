module volume

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import IO;
import List;
import Set;
import String;
import util::Benchmark;

void RunBenchMarkProject()
{
	//model = createM3FromEclipseProject(|project://MyTestJava|);
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	//model = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|);
	
	println(benchmark((			
		"option2" : void() {GetProjectLines2(model);},
		"option1" : void() {GetProjectLines(model);}
		)));
}

void GetMethodVolumes()
{
	//model = createM3FromEclipseProject(|project://MyTestJava|);
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	println(GetMethodVolumes(model));
}

int GetProjectVolume()
{
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	return GetProjectLines(model);
}

void DumpProjectLines()
{
	model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	GetProjectLines_int({file | file <- model@containment.from, file.scheme == "java+compilationUnit"}, model@documentation.comments);
}





// Seemingly useless interface, but it is usefull so we can test the wrapped function.
// The problem is that when we use the createM3FromEclipseFile function to create a model of a single file
// for some reason, we cannot read the "compilation unit" from that model. I think this is a bug, because we also
// get an error if we click the line in the console.
int GetProjectLines(M3 model)
{
	return size(GetProjectLines_int({file | file <- model@containment.from, file.scheme == "java+compilationUnit"}, model@documentation.comments));
}

list[str] GetProjectLines_int(set[loc] files, set[loc] cmts)
{
	// Make a map from source files (loc) to the contents of that file (str)	
	rel[str content, str file] Data = {<readFile(file), file.path> | file <- files };
	
	// Get the location of all the comments from the model
	rel[str file, str comment] comments = { <cmt.path, readFile(cmt)> | cmt <- cmts};
	
	// make sure to add an empy comment section for files that do not have any comments
	rel[str file, str comments] emptyComments = { <x,""> | x <- Data.file - comments.file };
	comments = comments + emptyComments;
	
	// Use composition to get a relation from source lines in a file to comments in that file
	rel[str content, str comments] contentToComment = Data o comments;
		
	// remove the comments from the source content, split on CR return and remove empty lines to get SLOC
	return [ x | x <- [ *split("\n", RemoveFromString(content, contentToComment[content])) | content <- contentToComment.content ], trim(x) != ""];
}

str RemoveFromString(str target, set[str] toRemove)
{
	for(remove <- toRemove)
		target = replaceFirst(target, remove, "");
		
	return target;
}

map[loc method, int SLOC] GetMethodVolumes(M3 model)
{
	// Make a map from method to method content	
	map[loc method,str content] Data = (method: readFile(method) | method <- model@containment.to, method.scheme == "java+method" );
	
	// And one from method to the containing file 
	map[loc method,str file] methodToFile = ( to:from.path | <from,to> <- model@containment+, from.scheme == "java+compilationUnit", to.scheme == "java+method");
	
	// Get the location of all the comments from the model
	set[loc] comments = model@documentation.comments;
	
	// For every comment...
	for(cmt <- comments)
	{	
		// Check all methods		
		for(method <- methodToFile.method)
		{
			// if the method and the comment are in the same file
			if(methodToFile[method] == cmt.path)
			{
				// Remove the comment from the method 
				// It may of course not be part of this method, but of another method in the file
				Data[method] = replaceAll(Data[method], readFile(cmt), "");
			}
		}
	}
	
	// Now calculate unit's the source lines of code by splitting the string in the CR and removing empty/whitespace lines 
	return SLOCperUnit = ( d:size([ line | line <- split("\n", Data[d]), trim(line) != ""]) | d <- Data );	
}

map[loc method, int SLOC] GetMethodVolumes(M3 model)
{
	// Make a map from method to method content	
	// map[loc method,str content] Data = (method: readFile(method) | method <- model@containment.to, method.scheme == "java+method" );
	
	// And one from method to the containing file 
	rel[loc method,str file] methodToFile = { <to,from.path> | <from,to> <- model@containment+, from.scheme == "java+compilationUnit", to.scheme == "java+method"};
	
	// Get the location of all the comments from the model
	rel[str file, str comment] fileToComment = { <c.path, readFile(c)> | c <- model@documentation.comments };
	
	// relation from method to possible comment in that method (possible because we can only map it to a file)
	rel[loc method, str comment] methodToComment = methodToFile o fileToComment;
	
	bla = { <x, RemoveFromString(x, methodToComment[x])> | x <- methodToComment.method }; 
	
	//// For every comment...
	//for(cmt <- comments)
	//{	
	//	// Check all methods		
	//	for(method <- methodToFile.method)
	//	{
	//		// if the method and the comment are in the same file
	//		if(methodToFile[method] == cmt.path)
	//		{
	//			// Remove the comment from the method 
	//			// It may of course not be part of this method, but of another method in the file
	//			Data[method] = replaceAll(Data[method], readFile(cmt), "");
	//		}
	//	}
	//}
	
	// Now calculate unit's the source lines of code by splitting the string in the CR and removing empty/whitespace lines 
	return SLOCperUnit = ( d:size([ line | line <- split("\n", Data[d]), trim(line) != ""]) | d <- Data );	
}

//********************************************************************************************************************
//**********												Unit tests 										**********
//********************************************************************************************************************
test bool correctCount()
{
	comments1 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|)@documentation.comments;
	sources1 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/A.java|};
	return size(GetProjectLines_int(sources1, comments1)) == 20;
}

// Tests below will not work because we get a relative path when we get the 'path' part of the comments
// and we get the full path from the 'path' part of the source's loc. Really extremely annoying!
//test bool ignoreComments()
//{
//	comments1 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|)@documentation.comments;
//	sources1 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/A.java|};
//	comments2 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/B.java|)@documentation.comments;
//	sources2 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/B.java|};
//	return GetProjectLines_int(sources1, comments1) == GetProjectLines_int(sources2, comments2);
//}
//
//test bool ignoreEmtyLines()
//{
//	comments1 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|)@documentation.comments;
//	sources1 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/A.java|};
//	comments2 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/C.java|)@documentation.comments;
//	sources2 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/C.java|};
//	return GetProjectLines_int(sources1, comments1) == GetProjectLines_int(sources2, comments2);
//}
//
//test bool doNotIgnoreLinesThatAreAlsoPartOfComments()
//{
//	comments1 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|)@documentation.comments;
//	sources1 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/A.java|};
//	comments2 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/D.java|)@documentation.comments;
//	sources2 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/D.java|};
//	return GetProjectLines_int(sources1, comments1) == GetProjectLines_int(sources2, comments2);
//}

test bool allInOne()
{
	// So now we can just build the one test that verifies if all of our classes return the same number of lines
	comments1 = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|)@documentation.comments;
	sources1 = { |java+compilationUnit:///Users/Bouke/Documents/SE/workspace3/MyTestJava/src/testCloneDetection/A.java|};
	
	model = createM3FromEclipseProject(|project://MyTestJava|);
	
	return 5 * size(GetProjectLines_int(sources1, comments1)) == GetProjectLines(model);
}

test bool equalImplementations()
{
	model = createM3FromEclipseProject(|project://MyTestJava|);
	
	return GetProjectLines2(model) == GetProjectLines(model);
}


//********************************************************************************************************************
//**********				Not used functions, only here for reference and to show benchmarks results 		**********
//********************************************************************************************************************

int GetProjectLines2(M3 model)
{
	return size(GetProjectLines2_int(model));
}

list[str] GetProjectLines2_int(M3 model)
{
	// Make a map from source files (loc) to the contents of that file (str)	
	map[str file,str content] Data = (file.path: readFile(file) | file <- model@containment.from, file.scheme == "java+compilationUnit" );
	
	// Get the location of all the comments from the model
	set[loc] comments = model@documentation.comments;
	
	// For every comment...
	for(cmt <- comments)
	{
		// Check if the file is part of our source file collection (this is kind of a senseless check, unless we made a programming boo boo)
		if(cmt.path in Data.file) 
		{
			// replace the comment in our local data with an empty string
			Data[cmt.path] = replaceAll(Data[cmt.path], readFile(cmt), "");
		}
		else
		{
			// todo: this should be some kind of assertion since it should never happen
			println("We have a comment line that is not part of the project");
		}
	}
	
	// make a list of all the source code lines which are not empty, or whitespace only
	// 
	SLOC = [codeLine | codeLine<-[ *split("\n",line) | line<- Data.content], trim(codeLine)!=""];
	
	// And return the number of source code lines
	return SLOC;
}

//int GetProjectLines2(M3 model)
//{
//	// Make a map from source files (loc) to the contents of that file (str)	
//	rel[str content, str file] Data = {<readFile(file), file.path> | file <- model@containment.from, file.scheme == "java+compilationUnit" };
//	
//	// Get the location of all the comments from the model
//	rel[str file, str comment] comments = { <cmt.path, readFile(cmt)> | cmt <- model@documentation.comments};
//	
//	// Use composition to get a relation from source lines in a file to comments in that file
//	rel[str content, str comments] contentToComment = Data o comments;
//	
//	// remove the comments from the source content, split on CR return and remove empty lines to get SLOC
//	return size( [ x | x <- [ *split("\n", trim(RemoveFromString(content, contentToComment[content]))) | content <- contentToComment.content ], trim(x) != ""]);
//}

