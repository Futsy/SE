module Visual

// Model
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import Map;
import Relation;
import Set;
import String;

import MatchDetection::Text::CloneDetection;

/**
 * Function that creates the json output
 * @param	All the clones per file (t1 and t3)
 * @param	All lines of code per file
 */
public void CreateJson(rel[loc, tuple[clone, int]] clones, map[loc,list[str]] lines)
{
	loc project = |project://Assignment2/output/input.json|;
	writeFile(project, NewLine("["));
	
	OutputNonDuplicates(project, domain(lines) - domain(clones));
	
	int i = 0;
	for (fst <- domain(clones)) {
		set[tuple[clone c, int t]] typeMap = clones[fst];
		mapsTo = { clonePair.c | clonePair <- typeMap };	

		appendToFile(project, NewLine("{"));
		appendToFile(project, NewLine("\"name\":\"" + FixPathing(fst.path) + "\","));
		CreateDuplicateObjects(project, lines, typeMap);
		CreateImportObjects(project, mapsTo);
		appendToFile(project, SelfDuplicate(mapsTo));
		appendToFile(project, NewLine("}"));
		
		
		if (i != size(domain(clones)) - 1)
			appendToFile(project, ",");
		i += 1;
	}

	// file closing thingy
	appendToFile(project, "]");
}

/**
 * Function that appends a new line
 * @param 	A string that needs to be prepended
 * @return	The input string with new line characters behind it
 */
private str NewLine(str input)
	= input + "\n\r";
 	
/**
 * Function that creates the output for non duplicate files
 * @param	The json file location
 * @param	The files which have no duplicates
 */
private void OutputNonDuplicates(loc project, set[loc] nonDupeFiles)
{
	for (f <- nonDupeFiles) {
		appendToFile(project, NewLine("{"));
		appendToFile(project, NewLine("\"name\":\"" + FixPathing(f.path) + "\","));
		appendToFile(project, NewLine("\"duplicate\": [],"));
		appendToFile(project, NewLine("\"imports\":[],"));
		appendToFile(project, NewLine("\"selfLink\": false"));
		appendToFile(project, NewLine("},"));
	}
}

/**
 * Function that writes all the information about the duplicate
 * @param	The json file location
 * @param	All the lines in the project
 * @param	The list of clones with this file
 */
private void CreateDuplicateObjects(loc project, map[loc,list[str]] lines, set[tuple[clone c, int t]] typeMap)
{
	//rel[clonePair x, clonePair y] mapsTo
	appendToFile(project, NewLine("\"duplicate\": ["));
	
	int k = 0;
	for (link <- typeMap) {
		appendToFile(project, NewLine("{"));
		
		// Add the code from this file
		str fileACode = "";
		for (ln <- lines[link.c.x.file][link.c.x.s .. link.c.x.end + 1])
			fileACode += ln + "\<br\>";
		
		appendToFile(project, NewLine("\"fileACode\":\"" + replaceAll(replaceAll(fileACode, "\"", "\\\""), "\t", "   ") + "\","));
		
		appendToFile(project, NewLine("\"cloneType\":<link.t>,"));
		
		str fileBCode = "";
		for (ln <- lines[link.c.y.file][link.c.y.s .. link.c.y.end + 1])
			fileBCode += ln + "\<br\>";
		
		appendToFile(project, NewLine("\"cloneCode\":\"" + replaceAll(replaceAll(fileBCode, "\"", "\\\""), "\t", "   ") + "\","));
		appendToFile(project, NewLine("\"cloneName\":\"" + FixPathing(link.c.y.file.path) + "\""));
		
		appendToFile(project, NewLine("}"));
		if (k != size(typeMap) - 1)
			appendToFile(project, ",");
		k += 1;
	}
	appendToFile(project, NewLine("],"));
}

/**
 * Function that adds the imports to the json for a specific file
 * @param	The json file location
 * @param	The list of clones with this file
 */
private void CreateImportObjects(loc project, rel[clonePair x, clonePair y] mapsTo)
{
	appendToFile(project, NewLine("\"imports\":["));
	int j = 0;
	for (link <- mapsTo) {
		appendToFile(project, NewLine("\"" + FixPathing(link.y.file.path) + "\""));
		
		if (j != size(mapsTo) - 1)
			appendToFile(project, ",");
		j += 1;
	}
	appendToFile(project, NewLine("],"));
}

/**
 * Function that fixes the absolute path
 * @param 	The path to the file
 * @return	A more readable verion
 */
private str FixPathing(str input)
	= RemoveBasePath(replaceAll(replaceAll(input, ".java", ""), "/", ".")); 

/**
 * Function that will provide output for the self duplicate
 * @param	The list of clones with this file
 * @return	"false" - if not a self duplicate
 *			"true"  - if it has a duplicate in its own file 
 */
private str SelfDuplicate(rel[clonePair x, clonePair y] mapsTo)
	= NewLine("\"selfLink\":" + (size({file | file <- mapsTo, file.y.file == file.x.file}) > 0 ? "true" : "false"));

/**
 * Function that will remove the base path from project files (hard coded for now)
 * @param	The path to a file
 * @return	The path to the file with the base path removed if the string starts with the base path
 			Input otherwise
 */
private str RemoveBasePath(str fullPath){
	list[str] splitPath = split(".Users.Bouke.Documents.Software engineering - Repos.SE - Assignment 1.Assignment2.smallsql0.21_src.src.smallsql.", fullPath);
	if(size(splitPath) == 0 )
		return fullPath;
	else
		return splitPath[1];
}
