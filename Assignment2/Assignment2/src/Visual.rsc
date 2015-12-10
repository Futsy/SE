module Visual

// Model
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import Relation;
import Set;
import String;

import MatchDetection::Text::Type1;

/**
 * Function that creates the json output
 */
public void CreateJson(rel[loc, loc] clones, M3 model)
{
	loc project = |project://Assignment2/output/input.json|;
	writeFile(project, "[\n\r");
	
	int i = 0;
	for (fst <- range(clones)) {
		// Add the opening tag
		appendToFile(project, "{\n\r");
		
		// Add the name
		appendToFile(project, "\"name\":\"" + replaceAll(replaceAll(fst.path, ".java", ""), "/", ".") + "\",\n\r");
		
		// Add the code from this file
		str fileACode = "";
		appendToFile(project, "\"fileACode\":\"" + fileACode + "\",\n\r");
		
		// Add the code that is a duplicate
		mapsTo = clones[fst];
		appendToFile(project, "\"duplicate\": [\r\n");
		int k = 0;
		for (link <- mapsTo) {
			appendToFile(project, "{\n\r");
			appendToFile(project, "\"cloneType\":1,\n\r");
			
			str fileBCode = "";
			appendToFile(project, "\"cloneCode\":\"" + fileBCode + "\",\n\r");
			appendToFile(project, "\"cloneName\":\"" + replaceAll(replaceAll(link.path, ".java", ""), "/", ".") + "\"\n\r");
			
			appendToFile(project, "}\n\r");
			if (k != size(mapsTo) - 1)
				appendToFile(project, ",");
			k += 1;
			
		}
		appendToFile(project, "],\r\n");
		
		// Add the imports
		appendToFile(project, "\"imports\":[\n\r");
		int j = 0;
		for (link <- mapsTo) {
			appendToFile(project, "\"" + replaceAll(replaceAll(link.path, ".java", ""), "/", ".") + "\"\n\r");
			
			if (j != size(mapsTo) - 1)
				appendToFile(project, ",");
			j += 1;
		}
		appendToFile(project, "]\n\r");
		
		// Add the closing bracket and comma for this object
		appendToFile(project, "}\n\r");
		
		if (i != size(range(clones)) - 1)
			appendToFile(project, ",");
		i += 1;
	}
		
	// file closing thingy
	appendToFile(project, "]");
}