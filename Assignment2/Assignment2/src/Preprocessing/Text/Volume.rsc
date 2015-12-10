module Preprocessing::Text::Volume

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import String;

/**
 * Get the SLOC for files without removing space
 */
public map[loc,list[str]] LinesOfCodeWithSpaces(set[loc] parts) 
	= (part : RemoveSingleLineComments(RemoveMultiLineComments(part)) | part <- parts);

/**
 * Get the SLOC for files
 */
public map[loc,list[str]] LinesOfCode(set[loc] parts) 
{
	map[loc, list[str]] fileToLines = ();
	
	for (part <- parts) {
		list[str] lines = RemoveSingleLineComments(RemoveMultiLineComments(part));
		fileToLines[part] = [RemoveWhiteSpace(line) | line <- lines];
	}
	
	return fileToLines;
}

/**
 * Removes all the white space from a string
 */
public str RemoveWhiteSpace(str line)
	= escape(line, (" " : "", "\t" : ""));

/**
 * Removes all the // comments
 */
public list[str] RemoveSingleLineComments(list[str] lines)
{
	linesInFile = [];
	
	for (line <- lines) {	
		// Remove all string literal content
		line = RemoveQuotes(line);			
		
		// Remove all the single line comments
		takeItFrom = findFirst(line, "//");
		
		fixedString = takeItFrom == -1 ? line : line[..takeItFrom];
		if (isEmpty(fixedString)) 
			continue;
		linesInFile += trim(fixedString);
	}
	
	return linesInFile;
}

/**
 * Removes all the /* to \*\/ comments
 */
public list[str] RemoveMultiLineComments(loc part)
{
	list[str] input = readFileLines(part);
	list[str] lines = [];
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
public str RemoveQuotes(str line)
	= visit(line) { case /<s:\"([^\"\\]|\\.)*\">/ => replaceAll(replaceAll(replaceAll(s, "/*", "~`"), "*/", "±§"), "//", "`§") };

