module alt::volume

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import IO;
import List;
import Set;
import String;
import util::Benchmark;

//These were our alternative ways of implementing the volume metric.
//The two solutions here both use the model's information on comments to remove
//comments from the source files. As we can see from the last test case, there is 
//a bug in the creation of the model that doesn't flag some comments as being a commen
//as a result, these functions do not return the correct metrics


int GetProjectLines(M3 model)
{
	return size(GetProjectLines_int(model));
}

list[str] GetProjectLines_int(M3 model)
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
	
	SLOC = [codeLine | codeLine<-[ *split("\n",line) | line<- Data.content], trim(codeLine)!=""];
	
	// And return the number of source code lines
	return SLOC;
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

int GetProjectLines2(M3 model)
{
	return size(GetProjectLines_int(model));
}

list[str] GetProjectLines_int(M3 model)
{
	// Make a map from source files (loc) to the contents of that file (str)	
	rel[str content, str file] Data = {<readFile(file), file.path> | file <- {file | file <- model@containment.from, file.scheme == "java+compilationUnit"} };
	
	// Get the location of all the comments from the model
	rel[str file, str comment] comments = { <cmt.path, readFile(cmt)> | cmt <- model@documentation.comments};
	
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

// UNITTESTS
test bool testSingleClassClean()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassClean|);
	
	return GetProjectLines(model) == 38;
}

test bool testSingleClassComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassComments|);
	
	return GetProjectLines(model) == 38;
}

test bool testSingleClassSpecialComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingleClassSpecialComments|);
	
	return GetProjectLines(model) == 38;
}

test bool testMultiClass()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeMultiClass|);
	
	return GetProjectLines(model) == 2 * 38;
}

test bool testSingleClassClean2()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassClean|);
	
	return GetProjectLines2(model) == 38;
}

test bool testSingleClassComment2()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassComments|);
	
	return GetProjectLines2(model) == 38;
}

test bool testSingleClassSpecialComment2()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingleClassSpecialComments|);
	
	return GetProjectLines2(model) == 38;
}

test bool testMultiClass2()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeMultiClass|);
	
	return GetProjectLines2(model) == 2 * 38;
}

