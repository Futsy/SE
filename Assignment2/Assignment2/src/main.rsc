module main

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General imports
import IO;
import List;
import Boolean;

// Helpers
import Preprocessing::Text::Volume;

// locations of projects for convenience (could just enter a path)
public loc testProject  = |project://testProject|;
public loc smallProject = |project://smallsql0.21_src|;
public loc largeProject = |project://hsqldb-2.3.1|;

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
	list[list[bool]] matrix = [];
	for (fileX <- files) {
		
		for (lineX <- lines[fileX]) {
			list[bool] line = [];
				
			for (fileY <- files) {
				for (lineY <- lines[fileY]) {
					line += lineX == lineY;
				}
			}
			
			matrix += [line];
		}
	}
	
	// output debug
	println("abcdefghij");
	for (row <- matrix) {
		str output = "";
		for (col <- row) {
			output += col ? "*" : "-";
		}
		println(output);
	}
	
	// Make list van elke diagonal
	list[list[bool]] diagonal = [];
	int i = size(matrix[0]) - 1; //\todo: careful on empty
	//testding = matrix[0][2];
	/*int j = i; \todo: don't do this but use the idea?
	for (int k = 0; k < j; j++) {
		
	}
	i -= 1;*/

}
