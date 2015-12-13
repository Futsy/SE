module MatchDetection::Text::Relations

import Preprocessing::Text::Matrix;

import List;
import Relation;
import Set;
import IO;
import analysis::graphs::Graph;
import String;

alias coord = tuple[int,int];
alias crel = rel[coord,coord];



/* A coordinate in the matrix <x,y> represents a line in file x and a line in file y
 * a 'true' in the matrix means that the two lines match. This function iterates the
 * matrix searching for cells for which both <x,y> and <x+1,y+1> match. All these pairs
 * are returned in a relation. 
 */

public crel GetT1Relations(LineMatrix m, bool mirror)
{
	height = size(m)-1;
	width = size(m[0])-1;
	
	return { <<x,y>,<x+1,y+1>> | x <- [0..width], y <- [0..height], m[y][x] && m[y+1][x+1], x < y || !mirror };
}

/* Determine clones from a type1 relation. */
crel GetT1Clones(crel candidates, int minimalSize)
{
	// All clone start coordinates are part of the set of coordinates that only occur in the first element of the relation pairs
	entries = top(candidates);
	// All clone end coordinates are part of the set of coordinates that only occur in the second element of the relation pairs
	exits = bottom(candidates);
	tclosure = candidates+;
	
	// Get the clones by taking all the elements from the transitive closure of the relation which have an element from 'entries'
	// as their left element and an elemement from 'exits' as their right element. Filter out any clones of insufficient size.
	return { <<x1,y1>,<x2,y2>> | <x1,y1> <- entries, <x2,y2> <- exits, <<x1,y1>,<x2,y2>> in tclosure, x2-x1 >= minimalSize-1 };
}

/* T3 clones consist of sequences of t1 clones. This function returns all the possible t1 clones of a certain length
 * this function differes from GetT1Clones in two aspects
 * - It returns only t1 clones of exactly 'size' length
 * - It returns all clones of that size, even if they overlap
 */
crel GetT3SubRelation(crel t1Relation, int size)
{
	r = range(t1Relation);
	tc = t1Relation+;
	return { <<x-size+1, y-size+1>, <x,y>> | <x,y> <- r, <<x-size+1, y-size+1>, <x,y>> in tc };
}

/* Get the type3 relations. We start out with the subrelations created by GetT3SubRelation
 * we then check for each of the elements in that relation, if we can find another element in the
 * relation that is at most 'maxHole' steps removed from the initial element in either x, y, or diagnoal
 * direction (only in the positive direction)
 */
crel GetT3Relations(crel t1Relation, int minimalSubSize, int maxHole)
{
	crel t3SubRel = GetT3SubRelation(t1Relation, minimalSubSize);

	/* Create a list of offset coordinates to check 
	 * If max hole is 3, we will check the following coordinates
	 * o - - - - 
	 * - - x x x 
	 * - x x x x 
	 * - x x x x 
	 * - x x x x 
	 */
	
	offsetsToCheck = [1..maxHole+2] * [1..maxHole+2] - <1,1>; 
	
	subRelRange = range(t3SubRel);
	subRelDomain = domain(t3SubRel);

	/* For each element in the range of the t3subrelations, see if we can find another element with a distance
	 * within the offsets. If we find one, add a connection between the two elements to the relation.
	 */
	return t1Relation + { <<x,y>,<x+offsetX,y+offsetY>> | <x,y> <- subRelRange, <offsetX,offsetY> <- offsetsToCheck, <x+offsetX,y+offsetY> in subRelDomain };
}

/* Get a list of t3 clones */
crel GetT3Clones(crel t3Relation, crel t1Rel)
{
	// Calculate the transitive closure of the t3 relation
	t3tclosure = t3Relation+;
	// And the transitive closure of the t1 relation. We need this to prevent this function from returning t1 clones 
	t1tclosure = t1Rel+;
	// Get all the 'entry only' elements from the relation
	entries = top(t3Relation);
	// And the 'exit-only' elements
	exits = bottom(t3Relation);
	
	// As with the t1 clones, we get all the pairs from the transitive closure that are combinations of entry and exit nodes. 
	// We do not need to filter on length since we know the relation only contains elements which have a valid length (the subrelations)
	// We do filter on the clone not being part of a t1 clone since we do not want duplicate duplicates.
	return { <<x1,y1>,<x2,y2>> | <x1,y1> <- entries, <x2,y2> <- exits, <<x1,y1>,<x2,y2>> in t3tclosure && <<x1,y1>,<x2,y2>> notin t1tclosure };
}
