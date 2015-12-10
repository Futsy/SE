module MatchDetection::Text::Type1

// General imports
import IO;
import List;

// Project imports
import Diagonal;
import Preprocessing::Text::Matrix;
import MatchDetection::Text::Relations;

// Aliases Type Clones
alias t1Pair  = tuple[loc file, int s, int end];
alias t1clone = tuple[t1Pair x, t1Pair y];

/**
 * Function that convers clones in relation form to list of clone objects
 * @param	The two files that were the basis for the clone detection
 * @return	A list of clones
 */
private list[t1clone] relToClones(filePair fp, crel clones) = 
	[ <<fp.first, y1, y2>,<fp.second, x1, x2>> | <<x1,y1>,<x2,y2>> <- clones ];


public tuple[list[t1clone] t1, list[t1clone] t3] GetClones(filePair fp, LineMatrix mat, int minimumLengthT1, int minSubLengthT3, int maxHolet3)
{
	crel t1rel = GetT1Relations(mat, fp.first == fp.second);
	crel t1clonesAsRel = GetT1Clones(t1rel, minimumLengthT1);
	
	// convert releation to clones
	list[t1clone] t1Clones = relToClones(fp, t1clonesAsRel);
	
	return <t1Clones, []>;
	
	t2SubRelations = GetT3SubRelation(t1rel, minSubLengthT3);
	t3Relations = GetT3Relations(t2SubRelations, minSubLengthT3, maxHolet3);
	t3cloneRelation = GetT3Clones(t3Relations, t1rel);
	t3Clones = relToClones(fp, t3cloneRelation);
	return <t1Clones, t3Clones>;
}


/**
 * Function that returns all the T1 clones of size >= threshold
 * @param	The threshold for the size
 * @param	The diagonals which contain duplications
 * @return	A list of all the type1 clones
 */
public list[t1clone] GetT1Clone(int threshold, Diagonals diagonals) = 
	[*GetT1ClonesInLine(threshold, diagonal) | diagonal <- diagonals];

/**
 * This function will retrieve all type1 clones from a diagonal
 * @param	The minimum size the clones should have
 * @param	The duplicate diagonal
 * @return	A list of all the type 1 clones
 * \todo: Problems if not(threshold >= 1)
 */
private list[t1clone] GetT1ClonesInLine(int threshold, list[duplicateLine] diagonal)
{
	if (size(diagonal) < threshold)
		return [];
	
	clones = [];	
	diagonalLength = size(diagonal);	
	cloneStart = 0;
	
	// Iterate over all the items in the diagonal line of the 'duplication matrix'
	// We use indexes here because we need to look forward in the list
	for (i <- [0..diagonalLength]) {
		duplicateLine current = diagonal[i];
		
		// If we are not at the end of the diagonal we can look ahead
		if (i < diagonalLength - 1) {				
			// Check if the next line is a 'continuation' of the current clone
			// If it is not, we have found the end of the current clone.			
			next = diagonal[i + 1];			
			if (!succeedingLines(current, next)) {
				// If the current clone is long enough, store it as a clone
				if (i - cloneStart >= threshold - 1) 
					clones += createClone(diagonal, cloneStart, i);
				
				// The next line will be the start of the next (possible) clone
				cloneStart = i + 1;
			}
		}
		// If we are at the end of the diagonal
		else if (i > 0) {
			// Check to see if the current line is a continuation of the previous line. 
			// If it is, the last line is also the end of the current clone.
			previous = diagonal[i - 1];
			if(succeedingLines(previous, current) && (i - cloneStart >= threshold - 1))	
				clones += createClone(diagonal, cloneStart, i);
		}	
	}
	return clones;
}

/**
 * Checks if the next duplicate is on the next line of both files
 * @param	First duplicate line (File a : 13, File b : 14)
 * @param	Second duplicate line (File a : 13, File b : 14)
 * @return	True if the second duplicate succeeds the first
 *			False on everything else
 */
private bool succeedingLines(duplicateLine first, duplicateLine second) =
	first.x.lineNr + 1 == second.x.lineNr && first.y.lineNr + 1 == second.y.lineNr; 

/**
 * Function that creates a t1clone using the start and end index of a diagonal
 * @param	The diagonal that is used to create the t1clone
 * @param	The start index
 * @param	The end index
 * @return	The type1 clone created from the diagonal
 * \todo: This does not hold for out of bound
 */
private t1clone createClone(list[duplicateLine] diagonal, int startIndex, int endIndex)
{
	s = diagonal[startIndex];
	e = diagonal[endIndex];
	return <<s.x.file, s.x.lineNr, e.x.lineNr>,<s.y.file, s.y.lineNr, e.y.lineNr>>;
}

/**
 * Function that 'pretty prints' a list of type1 clones
 * @param	The list of type1 clones to be printed 
 */
public void PrintT1Clones(list[t1clone] t1clones)
{
	for (c <- t1clones) {
		println("<c.x.file.file> [<c.x.s>..<c.x.end>] - <c.y.file.file> [<c.y.s>..<c.y.end>]");
	}
}

