module Diagonal

// General imports
import IO;
import List;
import util::Math;

// Project imports
import Preprocessing::Text::Matrix;

// Aliases Diagonals
alias fileLine 		= tuple[loc file, int lineNr];
alias duplicateLine = tuple[fileLine x, fileLine y];
alias Diagonals		= list[list[duplicateLine]];
alias Coordinates	= list[list[tuple[int x, int y]]];
alias Coordinate	= tuple[int x, int y];

/**
 * Gathers all the diagonals
 * @param	The comparison matrix
 * @return	The list of diagonals
 */
public Diagonals CheckDiagonals(fileMatrix matrix)
{
	Diagonals diagonals = [];
	
	for (filePair <- matrix) {
		comparisonMatrix = matrix[filePair];
	
		height = size(comparisonMatrix);
		width = size(comparisonMatrix[0]);

		diagonals += GetDiagonals(filePair.first, filePair.second, width, height, comparisonMatrix);
	}
	
	return diagonals;
}

/**
 * Function that will return all diagonals of the matrix, iterates 
 * all diagonal positions and then adds these as a list.
 * @param 	The source code from the first file
 * @param 	The source code from the second file
 * @param	The width of the comparison matrix
 * @param	The height of the comparison matrix
 * @param	The comparison matrix (list[list[bool]])
 * @return	All diagonals, which are lists of <<loc, int>, <loc, int>>
 */
public Diagonals GetDiagonals(loc first, loc second, int width, int height, LineMatrix matrix)
{
	Diagonals diagonals = [];
	
	for (coordinates <- getAllDiags(matrix, first == second)) {
		diagonal = [];
		
		// For each coordinate we check if it is in the matrix (reverse!!) and add it
		for (coordinate <- coordinates) {
			if (matrix[coordinate.y][coordinate.x]) {
				diagonal += <<first, coordinate.y>, <second, coordinate.x>>;
			}
		}
		
		// We are not interested in diagonals that do not have any true values (no dupes)
		if (!isEmpty(diagonal)) {
			diagonals += [diagonal];
		}
	}
		
	return diagonals;	
}

/**
 * This function obtains all the diagonal positions from the matrix
 * @param	The param being used for comparison
 * @param	A flag set to true if a file is compared to itself (in
 *			which case it should not take the center diagonal)
 * @return	All the coordinates in the matrix
 */
private Coordinates getAllDiags(LineMatrix mat, bool onlyBelowOrigin)
{
	try {
		height = size(mat);	
		width = size(mat[0]);
		
		/* Create all coordinates in the matrix to start diagonals from. 
		 * This is equal to the top row and the left column
		 * optionally omit all diagonals top-left of the origin. 
		 * This is used for when we want to compare clone matrices
		 * created by comparing a file with itself. In that case it makes
		 * no sense to look both beneath and above the matrix' diagonal
		 */
		startCoords = [];
		if (onlyBelowOrigin) {
			startCoords = [0] * [1..height];
		}
		else {
			startCoords = [0] * [0..height] + [0..width] * [0];
		}
		
		// Use GetDiagonals to get diagonals starting at those coordinates
		return [GetDiagonal(c, width, height) | c <- dup(startCoords)];
	}
	catch IndexOutOfBounds(i) : return [];
}

/** 
 * Return a list of coordinates that form a diagonal line in a matrix of a specified width and height
 * from a specified starting point. 
 */
private list[Coordinate] GetDiagonal(Coordinate startCoord, int width, int height) =
	[<startCoord.x + i, startCoord.y + i> | i <- [0..min(width - startCoord.x, height - startCoord.y)]];
