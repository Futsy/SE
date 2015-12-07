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
import Matrix;
import Diagonal;
import MatchDetection::Text::Type1;

// Locations of projects for convenience (could just enter a path)
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
	
	for(filePair <- filesToCompare)
	{
		// Create Matrix for this filepair
		mat = CreateLineMatrix(sourceLines[filePair.x], sourceLines[filePair.y]);
		// Get diagonals from this filepair
		diagonals = GetDiagonals(filePair.x, filePair.y, size(mat[0]), size(mat), mat);
		// Get clones 
		t1clones = GetT1Clone(6, diagonals);
		
		PrintT1Clones(t1clones);
	}
}
