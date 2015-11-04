module volume

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import String;

// Get all the comments
public list[str] AllComments(M3 model)
	= [trim(comment) | comment <- [*readFileLines(line) | line <- 
	[doc.comments | doc <- model@documentation]]];

// Get the name and total source lines of code in the parts
public rel[loc, int] LinesOfCode(set[loc] parts, list[str] comments) 
	= {LinesOfCodeInPart(part, comments) | part <- parts};

// Get the name and the amount of source lines of code as a tuple
public tuple[loc, int] LinesOfCodeInPart(loc part, list[str] comments)
	= <part, size(ListOfCodeLines(part, comments))>;	

// Function that creates a list of all SLOC in the part
public list[int] ListOfCodeLines(loc part, list[str] comments) //\todo: real men never double trim
	= [1 | line <- readFileLines(part), trim(line) notin comments && !isEmpty(trim(line))];