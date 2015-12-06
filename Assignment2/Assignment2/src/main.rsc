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
	
	// Create a comparison map from file to file giving a matrix of duplications (bools)
	println("Creating matrix");
	fileMatrix matrix = CreateFileMatrix(LinesOfCode(files));
	
	// Now we obtain the diagonals from the matrices
	Diagonals diagonals = CheckDiagonals(matrix);
	
	// t1clones = GetT1Clone(6, diagonals);
	//iprintln(t1clones);
	////println(size(clones));
	//
	//iprintln(GetT3Clones(10, t1clones));
}
