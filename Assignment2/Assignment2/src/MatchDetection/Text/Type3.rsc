module MatchDetection::Text::Type3

// General imports
import IO;
import List;
import String;

import MatchDetection::Text::RelationsTest;
import MatchDetection::Text::Relations;
import Preprocessing::Text::Matrix;

// Project imports
import Diagonal;
import Preprocessing::Text::Matrix;
import MatchDetection::Text::Relations;

import lang::java::jdt::m3::Core;
import Preprocessing::Text::Volume;

// Project imports
import Preprocessing::Text::Volume;
import Preprocessing::Text::Matrix;
import util::Math;

// SUT
import MatchDetection::Text::Type1;

// Aliases Type Clones
alias t1Pair  = tuple[loc file, int s, int end];
alias t1clone = tuple[t1Pair x, t1Pair y];
	
private LineMatrix StringsToLineMat(list[str] lines) = 
		[[ c == "*" | c <- split(" ", line) ] | line <- lines];

list[str] matrix = [
"* - - - - - - - - -",
"- * - - - - - - - -",
"- - * - - - - - - -",
"- - - * - - - - - -",
"- - - - - - - - - -",
"- - - - - - - - - -",
"- - - - - - * - - -",
"- - - - - - - * - -",
"- - - - - - - - * -"];

list[str] matrix2 = [
"* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - - * - - - - - - * - - - - - - - - - - - - - - - - * - - - - - - * - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - - * - - - - - - * - - - - - - - - - - - - - - - - * - - - - - - * - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - - * - - - - - - * - - - - - - - - - - - - - - - - * - - - - - - * - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - -", 
"- - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - - * - - - - - - * - - - - - - - - - - - - - - - - * - - - - - - * - - - - - - - -", 
"- - - - - * - - - * - - - - * - - - - - - * - - - - - - - * - - - * - - - - * - - - - - - * - - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - - -", 
"- - - - - - - - - - - - - - - - - - - - - - - - - * - - - - - - - - - - - - - - - - - - - - - - - * - - -", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *", 
"- - - - - - - - - - - - * - - - - - - * - - - - - - * * - - - - - - - - * - - - - - - * - - - - - - * * *"]; 

bool blabla()
{	
	t1rel = GetT1Relations(StringsToLineMat(matrix2), true);	
	t3rel = GetT3Relations(t1rel,4, 4);
	t3subs = GetT3SubRelation(t1rel, 4);
	
	println("Subrels: <t3subs>\n\n");
	print("T1 relation: <t1rel>\n\n");
	print("T3 relation: <t3rel-t3subs>\n\n");
	
	println("T3 clones: <GetT3Clones(t3rel, t1rel)>\n\n");
	
	t3SubRelations = GetT3SubRelation(t1rel, minSubLengthT3);
	t3Relations = GetT3Relations(t3SubRelations, minSubLengthT3, maxHolet3);
	t3cloneRelation = GetT3Clones(t3Relations, t1rel);
	t3Clones = relToClones(fp, t3cloneRelation);
	
	return GetT3Clones(t3rel, t1rel) == {};
}

public list[t1clone] blabla2(loc project, int threshold)
{
	set[loc] files = files(createM3FromEclipseProject(project));
	
	// Process all source lines
	sourceLines = LinesOfCode(files);
	
	// Make a list of file pair to compare:
	list[tuple[loc x, loc y]] filesToCompare = [];
	for(f1 <- files)
	{
		for(f2 <- files)
		{
			if (<f2,f1> notin filesToCompare)
				filesToCompare += <f1,f2>;
		}
	}
	
	t1clones = [];
	t3clones = [];
	
	for(filePair <- filesToCompare)
	{
		// Create Matrix for this filepair
		mat = CreateLineMatrix(sourceLines[filePair.x], sourceLines[filePair.y]);
			
		printLineMatrix(mat);

		// Get clones 
		<t1clonesTmp, t3clonesTmp> = GetClones(filePair, mat, threshold, 4, 4);
		
		// Add them to list
		t1clones += t1clonesTmp;
		t3clones += t3clonesTmp;
	}
	
	println("T1"); PrintT1Clones(t1clones);
	println("T3"); PrintT1Clones(t3clones);
	
	return t1clones;
}
