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
 * Function that iterates all the files (compares all to each other). For each
 * file compared it gives the two file locations and a duplication matrix
 * @param 	A map of locations of source files and the source code that belongs to it
 * @return 	A mapping from <File1 to File2> with the duplication table
 */
public fileMatrix CreateFileMatrix(map[loc, list[str]] files)
{
	fileMatrix mat = ();

	map[loc, list[int]] hashed = ();
	for (first <- files) {
		hashed[first] = [Hash(line) | line <- files[first]];
	}
	
	// Iterate the files and compare them
	for (first <- files) {
		// We are not interested in A compared to B AND B compared to A
		// Keep the map asymmetric
		//for (second <- [file | file <- files, <file, first> notin mat]) {
		for (second <- files) {
			if (<second, first> in mat)
				continue;
		
			// Add the comparison to <first, second> -> Matrix
			// We pass the actual code here for the comparison in CreateLineMatrix
			mat[<first, second>] = CreateLineMatrix(hashed[first], hashed[second]);
		}
	}
	//printFileMatrix(mat);
	return mat;
}

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
 * Function that hashes a string
 * @param	The input string
 * @return	Hashed value
 */
 private int Hash(str input)
 {
 	int hash = 7;
 	for (i <- [0..size(input)]) {
 		hash = hash * 33 + charAt(input, i);
 	}
 	return hash;
 }

/**
 * Function to pretty print a file matrix 
 * @param 	FileMatrix to print
 */
public void printFileMatrix(fileMatrix matrix)
{
	for (fp <- matrix) {
		println("<fp.first.file> vs <fp.second.file>");
		for (row <- matrix[fp])	{
			str output = "";
			for (col <- row) {
				output += col ? "*" : "-";
			}
			println(output);
		}
	}
}