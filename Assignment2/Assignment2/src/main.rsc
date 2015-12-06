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

// Locations of projects for convenience (could just enter a path)
public loc testProject  = |project://testProject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;
public loc ppUnitTest 	= |project://TestPreprocessing|;

// Aliases Type Clones
alias t1Pair  = tuple[loc file, int s, int end];
alias t1clone = tuple[t1Pair x, t1Pair y];
alias t3clone = list[t1clone];

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
	
	//
	//t1clones = GetT1Clone(6, diagonals);
	//iprintln(t1clones);
	////println(size(clones));
	//
	//iprintln(GetT3Clones(10, t1clones));
}

list[t1clone] GetT1Clone(int threshold, Diagonals diagonals) = 
	[*GetT1ClonesInLine(threshold, diagonal) | diagonal <- diagonals];

/* Get all the clones from a single diagonal line in the 'duplication matrix'
 * Threshold: The minumum number of lines that a clone should have
 * Diagonal: A list of file-linenumber pairs. Each pair represents a duplicate line
 */
list[t1clone] GetT1ClonesInLine(int threshold, list[duplicateLine] diagonal)
{
	clones = [];	
	diagLen = size(diagonal);	
	cloneStart = 0;
	
	
	// Iterate over all the items in the diagonal line of the 'duplication matrix'
	for(i <- [0..diagLen])
	{
		curr = diagonal[i];
		
		// If we are not at the end of the line...
		if(i < diagLen-1)
		{				
			// Check if the next line is a 'continuation' of the current clone
			// If it is not, we have found the end of the current clone.			
			next = diagonal[i+1];			
			if(!succeedingLines(curr,next))  
			{
				// If the current clone is long enough, store it as a clone
				if(i - cloneStart >= threshold) clones += createClone(diagonal, cloneStart, i);
				
				// The next line will be the start of the next (possible) clone
				cloneStart = i+1;
			}
		}
		// If we are at the end of the line...
		else if(i > 0)
		{
			// Check to see if the current line is a continuation of the previous line. 
			// If it is, the last line is also the end of the current clone.
			prev = diagonal[i-1];
			if(succeedingLines(prev,curr) && (i - cloneStart >= threshold))	clones +=  createClone(diagonal, cloneStart, i);
		}		
	}
	return clones;
}

list[t3clone] GetT3Clones(int threshold, list[t1clone] t1Clones)
{
	if (threshold < 2)
		return [];

	list[t3clone] t3Clones = [];
	
	for (t1Clone <- t1Clones) {
		// alias t1Pair  = tuple[loc file, int s, int end];
		// alias t1clone = tuple[t1Pair x, t1Pair y];
		t3clone t3Clone = [t1Clone];
		
		list[t1clone] t1 = [t1Clone];
		while (true)
		{
			t1 = FindNextType1(threshold, t1[0], t1Clones, false, true);
			if (size(t1) == 0)
				break;
			t3Clone += t1;
		}
		
		if (size(t3Clone) > 1)
			t3Clones += [t3Clone];
	}
	
	return t3Clones;
}

list[t1clone] FindNextType1(int threshold, t1clone clone, list[t1clone] t1Clones, bool incX, bool incY)
{
	for (bound <- [2..threshold + 1]) {
		for (t1Clone2 <- t1Clones) {
			if (clone.x.end + (incX ? bound : 1) == t1Clone2.x.s && (clone.y.end + (incY ? bound : 0) == t1Clone2.y.s) && clone.x.file == t1Clone2.x.file && clone.y.file == t1Clone2.y.file){
				return [t1Clone2];
			}
		}
	}
	
	return [];
}


bool succeedingLines(duplicateLine first, duplicateLine second) =
	first.x.lineNr+1 == second.x.lineNr && first.y.lineNr+1 == second.y.lineNr; 

t1clone createClone(list[duplicateLine] diagonal, int startInx, int endInx)
{
	s = diagonal[startInx];
	e = diagonal[endInx];
	return <<s.x.file, s.x.lineNr, e.x.lineNr>,<s.y.file, s.y.lineNr, e.y.lineNr>>;
}

