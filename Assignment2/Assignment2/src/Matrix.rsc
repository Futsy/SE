module Matrix

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

	// Iterate the files and compare them
	for (first <- files) {
		// We are not interested in A compared to B AND B compared to A
		// Keep the map asymmetric
		for (second <- [file | file <- files, <file, first> notin mat]) {
			// Add the comparison to <first, second> -> Matrix
			// We pass the actual code here for the comparison in CreateLineMatrix
			mat[<first, second>] = CreateLineMatrix(files[first], files[second]);
		}
	}
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
private LineMatrix CreateLineMatrix(list[str] slocFirst, list[str] slocSecond)
{
	mat = [];
	
	for (lineX <- slocFirst) {
		list[bool] row = [];
		for (lineY <- slocSecond) {
			row += lineX == lineY;
		}
		mat += [row];
	}
	
	return mat;
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