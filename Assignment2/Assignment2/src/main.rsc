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

// Helpers
import Preprocessing::Text::Volume;

// locations of projects for convenience (could just enter a path)
public loc testProject  = |project://testProject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;
public loc ppUnitTest 	= |project://TestPreprocessing|;

// Aliases
alias lineMatrix = list[list[bool]];			// A matrix of lines in two files. A 'true' in a cell indicates that both lines have the same content
alias filePair = tuple[loc,loc];				
alias fileMatrix = map[filePair, lineMatrix];	// A matrix of lineMatrices. Contains a lineMatrix for each filePair in the project

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
	
	
	// Create the matrix
	//list[list[bool]] matrix = [];
	//for (fileX <- files) {
	//	
	//	for (lineX <- lines[fileX]) {
	//		list[bool] line = [];
	//			
	//		for (fileY <- files) {
	//			for (lineY <- lines[fileY]) {
	//				line += lineX == lineY;
	//			}
	//		}
	//		
	//		matrix += [line];
	//	}
	//}
	
	matrix = CreateFileMatrix(lines);
	
	// output debug
	println("abcdefghij");
	file = [*domain(lines)][0];
	
	i = 0;
	
	for(fx <- files)
	{
		for(fy <- files)
		{
			println("<fx.path> vs <fy.path>:");

			for (row <- matrix[<fx,fy>]) {
				str output = "";
				for (col <- row) {
					output += col ? "*" : "-";
				}
				println(output);
			}
			
			CreateCsvFromMatrix(matrix[<fx,fy>], fx.path, fy.path, i);
			i += 1;
		}
	}
	
	//CreateCsvFromMatrix(matrix[<file,file>]);
	
	// Make list van elke diagonal
	//list[list[bool]] diagonal = [];
	//int i = size(matrix[0]) - 1; //\todo: careful on empty
	//testding = matrix[0][2];
	/*int j = i; \todo: don't do this but use the idea?
	for (int k = 0; k < j; j++) {
		
	}
	i -= 1;*/

}

void CreateCsvFromMatrix(list[list[bool]] matrix, str fx, str fy, int suffix)
{
	// Wirte header
	loc f = |project://Assignment2/output/| + "clones_<suffix>.csv";
	writeFile(f, "x,y,file1,line1,file2,line2\r\n");
	
	// Write a row to the file for each row in the matrix
	// TODO: Add support for file names and line number in file.
	for( X <- [0..size(matrix)])
	{
		for( Y <- [0..size(matrix[X])])
		{
			if(matrix[X][Y]) appendToFile(f,"<X>,<Y>,<fx>,<X> <fy>,<Y>\r\n");
		}
	}
}

fileMatrix CreateFileMatrix(map[loc, list[str]] files)
{
	fileMatrix mat = ();
	for(fx <- files)
	{
		for(fy <- files)
		{
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
