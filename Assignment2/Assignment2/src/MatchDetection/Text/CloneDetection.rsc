module MatchDetection::Text::CloneDetection

// General imports
import IO;
import List;

// Project imports
import Diagonal;
import Preprocessing::Text::Matrix;
import MatchDetection::Text::Relations;

// Aliases Type Clones
alias clonePair  = tuple[loc file, int s, int end];
alias clone = tuple[clonePair x, clonePair y];

/**
 * Function that convers clones in relation form to list of clone objects
 * @param	The two files that were the basis for the clone detection
 * @return	A list of clones
 */
private list[clone] relToClones(filePair fp, crel clones) = 
	[ <<fp.first, y1, y2>,<fp.second, x1, x2>> | <<x1,y1>,<x2,y2>> <- clones ];


/**
 * Function that finds (type 1 and type 3) clones in a pair of files
 * @param 	The file pair in which clones are saught
 * @param 	The line matrix create from those two files
 * @param	Minimum length that a t1 clone should have
 * @param	Minimum number of consecutive lines in a t3 clone
 * @param	Maximum gap between consecutive lines in a t3 clone
 * @return  a tuple of a list of t1 clones and a list of t3 clones 
 */
public tuple[list[clone] t1, list[clone] t3] GetClones(filePair fp, LineMatrix mat, int minimumLengthT1, int minSubLengthT3, int maxHolet3)
{
	crel t1rel = GetT1Relations(mat, fp.first == fp.second);
	crel t1clonesAsRel = GetT1Clones(t1rel, minimumLengthT1);
	
	// convert releation to clones
	list[clone] t1Clones = relToClones(fp, t1clonesAsRel);
	
	t3Relations = GetT3Relations(t1rel, minSubLengthT3, maxHolet3);
	t3cloneRelation = GetT3Clones(t3Relations, t1rel);
	t3Clones = relToClones(fp, t3cloneRelation);
	return <t1Clones, t3Clones>;
}

/**
 * Function that 'pretty prints' a list of type1 clones
 * @param	The list of type1 clones to be printed 
 */
public void PrintClones(list[clone] clones)
{
	for (c <- clones) {
		println("<c.x.file.file> [<c.x.s>..<c.x.end>] - <c.y.file.file> [<c.y.s>..<c.y.end>]");
	}
}

