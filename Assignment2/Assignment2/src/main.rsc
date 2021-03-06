module main

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General imports
import IO;
import List;
import Boolean;
import Map;
import Set;
import String;

// Project imports
import Preprocessing::Text::Volume;
import Preprocessing::Text::Matrix;
import Diagonal;
import MatchDetection::Text::CloneDetection;
import Visual;

// Locations of projects for convenience (could just enter a path)
public loc multiTest	= |project://TestClonesMultiFileMultiClone2|;
public loc testProject  = |project://testProject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;
public loc ppUnitTest 	= |project://TestPreprocessing|;

/**
 * Main entry for the duplication function (Report)
 * @param	The project you want to report the dupes of
 */
public void ReportDuplicates(loc project)
{
	// Get all the files in the project
	println("Obtaining files");
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
	
	rel[loc, tuple[clone, int]] fileRel = {};
	
	t1clones = [];
	t3clones = [];
	
	for(filePair <- filesToCompare)
	{
		// Create Matrix for this filepair
		mat = CreateLineMatrix(sourceLines[filePair.x], sourceLines[filePair.y]);

		// Get clones 
		<t1clonesTmp, t3clonesTmp> = GetClones(filePair, mat, 6, 4, 2);
		
		// Add them to list
		t1clones += t1clonesTmp;
		t3clones += t3clonesTmp;
		
		if(size(t1clonesTmp) > 0){
			println("Type 1:");
			PrintClones(t1clonesTmp);
		}
		
		if(size(t3clonesTmp) > 0){
			println("Type 3:");
			PrintClones(t3clonesTmp);
		}
	}
	
	// Add the inverse of the clones 
	t1clones += [ <y,x> | <x,y> <- t1clones];
	t3clones += [ <y,x> | <x,y> <- t3clones];
	
		
	// Create a relation file to clones in that file
	fileRel += { <clone.x.file, <clone, 1>> | clone <- (t1clones) };
	fileRel += { <clone.x.file, <clone, 3>> | clone <- (t3clones) };
	
	// Use that relation to create a json file for visualization
	CreateJson(fileRel, LinesOfCodeWithSpaces(files));
}
