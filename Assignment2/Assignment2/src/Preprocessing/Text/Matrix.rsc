module Preprocessing::Text::Matrix

// General imports
import IO;
import List;
import String;

// Aliases Matrix
alias LineMatrix 	= list[list[bool]];	
alias filePair 		= tuple[loc first, loc second];				
alias fileMatrix 	= map[filePair, LineMatrix];

/**
 * Function that will check each line in file 1 to that of file 2
 * @param 	The source code from the first file
 * @param 	The source code from the second file
 * @return 	A representation of the duplications (list[list[bool]])
 *			this works as Row, Columns (Not X, Y)
 * \todo: This needs some real performance
 */
public LineMatrix CreateLineMatrix(list[value] slocFirst, list[value] slocSecond)
{
	mat = [];
	
	for (lineX <- slocFirst) {
		mat += [[lineX == lineY | lineY <- slocSecond]];
	}
	
	return mat;
}

/**
 * Function to pretty print a line matrix 
 * @param 	LineMatrix to print
 */
public void printLineMatrix(LineMatrix matrix)
{
	for (row <- matrix)	{
		str output = "";
		for (col <- row) {
			output += col ? "* " : "- ";
		}
		println(output);
	}
}