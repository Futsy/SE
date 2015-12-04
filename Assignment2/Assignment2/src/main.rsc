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
import util::Math;

// Helpers
import Preprocessing::Text::Volume;

// locations of projects for convenience (could just enter a path)
public loc testProject  = |project://testProject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;
public loc ppUnitTest 	= |project://TestPreprocessing|;

// Aliases
alias lineMatrix = list[list[bool]];			// A matrix of lines in two files. A 'true' in a cell indicates that both lines have the same content
alias filePair = tuple[loc first,loc second];				
alias fileMatrix = map[filePair, lineMatrix];	// A matrix of lineMatrices. Contains a lineMatrix for each filePair in the project

alias fileLine = tuple[loc file, int lineNr];
alias dupLine = tuple[fileLine x, fileLine y];

alias t1clone = tuple[tuple[loc,int,int],tuple[loc,int,int]];
alias t3clone = list[t1clone];

alias coord = tuple[int x, int y];

/**
 * Main entry for the duplication function (Report)
 * @param the project you want to report the dupes of
 */
public void ReportDuplicates(loc project)
{
	println("-- Creation ----------------");
	
	// Create model
	model = createM3FromEclipseProject(project);
	println(" - Created model");
	
	// Get all the files
	set[loc] files = files(model);
	//\todo: Volume requires tests
	map[loc, list[str]] lines = LinesOfCode(files);
	
	matrix = CreateFileMatrix(lines);
	
	list[list[dupLine]] diagonals = [];
	
	for(filePair <- matrix)
	{				
		lm = matrix[filePair];
		
		height = size(lm);
		width = size(lm[0]);	// TODO: fucked if it's empty
		
		diagonals += GetDiagonals(filePair.first, filePair.second, width, height, lm);
	}
	
	clones = GetT1Clone(6, diagonals);
	iprintln(clones);
	println(size(clones));
}

fileMatrix CreateFileMatrix(map[loc, list[str]] files)
{
	fileMatrix mat = ();
	
	for(fx <- files)
	{
		for(fy <- files)
		{
			if(<fy,fx> notin mat)
				mat[<fx,fy>] = CreateLineMatrix(files[fx], files[fy]);
		}
	}
	return mat;
}

lineMatrix CreateLineMatrix(list[str] x, list[str] y)
{
	mat = [];
	for(lx <- x)
	{
		list[bool] row = [];
		for(ly <- y)
		{
			row += ly == lx;
		}
		mat += [row];
	}
	return mat;
}

list[list[dupLine]] GetDiagonals(loc fx, loc fy, int width, int height, lineMatrix matrix)
{
	list[list[dupLine]] diagonals = [];
	
	for(coords <- getAllDiags(matrix))
	{
		diagonal = [];
		
		for(c <- coords)
		{
			if(matrix[c.x][c.y])
				diagonal += <<fx,c.x>,<fy,c.y>>;
		}
		
		if(size(diagonal) > 0) diagonals += [diagonal];
	}
		
	return diagonals;	
}

list[list[tuple[int x,int y]]] getAllDiags(lineMatrix m)
{
	try
	{
		height = size(m);	
		width = size(m[0]);
		
		// Create all coordinates in the matrix to start diagonals from. 
		// This is equal to the top row and the left column
		topRowCoords = [0..width] * [0];
		leftColCoords = [0] * [0..height];
		startCoords = dup(topRowCoords + leftColCoords);
		
		// Use GetDiagonals to get diagonals starting at those coordinates
		return [GetDiagonal(c, width,height) | c <- startCoords];
	}
	catch IndexOutOfBounds(i) : return [];
}

/* Return a list of coordinates that form a diagonal line in a matrix of a specified width and height
 * from a specified starting point. */
public list[coord]GetDiagonal(coord startCoord, int width, int height) =
	[<startCoord.x+i, startCoord.y+i> | i <- [0..min(width-startCoord.x, height - startCoord.y)]];

list[t1clone] GetT1Clone(int threshold, list[list[dupLine]] diagonals)
{
	clones = [];

	for(diagonal <- diagonals)
	{
		int sequence = 0;
		bool inClone = false;
		
		diagLen = size(diagonal);
		
		tuple[int x,int y] cloneStart = <diagonal[0].x.lineNr,diagonal[0].y.lineNr>;	// todo bound check
		
		for(i <- [0..diagLen])
		{
			curr = diagonal[i];
			
			if(i < diagLen-1)
			{				
				next = diagonal[i+1];
				// look forward
				if(!(curr.x.lineNr+1 == next.x.lineNr && curr.y.lineNr+1 == next.y.lineNr))
				{
					// End of clone
					int cloneLength = curr.x.lineNr - cloneStart.x;
					if(cloneLength >= threshold) 
						clones += <<curr.x.file, cloneStart.x, curr.x.lineNr>,<curr.y.file, cloneStart.y, curr.y.lineNr>>;
					
					// reset start of clone to current line
					cloneStart = <next.x.lineNr, next.y.lineNr>;
				}
			}
			else if(i > 0)
			{
				prev = diagonal[i-1];
				if(curr.x.lineNr == prev.x.lineNr+1 && curr.y.lineNr == prev.y.lineNr+1)
				{
					if(curr.x.lineNr - cloneStart.x >= threshold) 
						clones += <<curr.x.file, cloneStart.x, curr.x.lineNr>,<curr.y.file, cloneStart.y, curr.y.lineNr>>;
				}
			}		
		}
	}
	return clones;
}

