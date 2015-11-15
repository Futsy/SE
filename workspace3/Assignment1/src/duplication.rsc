module duplication

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import Set;
import String;

import volume;

/**
 * Calculates the duplication in a project
 */
public int CalculateDuplication(map[loc, list[str]] l)
{
	// We get a map of file to the lines in that file. 
	// In order to be able to uniquely define lines later on, we need the combination
	// <loc,line number>
	// so map[loc, lrel[loc, int, str]] 
	map[loc, lrel[loc, int, str]] lines = (k : [<k, I, l[k][I]> | I <- [0..size(l[k])]] | k <- l);
	
	// Now we create a list of blocks of 6 subsequent lines in all files. 
	// As a group of 6 lines that appears (without alterations) in more than one place is a duplicate
	allBlocksOf6 = [*[take(6, lines[k][block..]) | block <- [0..size(lines[k]) - 6]] | k <- lines];
	
	// Use the getDuplicates function to get all 6 line blocks which occur multiple times in the input
	// we only check the str part of the lines in the blocks.
	duplicates = getDuplicates(allBlocksOf6);	
	
	// We now have a list of duplicate blocks. We flatten it to make a set of <file, line number> tuples
	// to get all unique duplicate lines
	return size({ *[ <f, li> | <f,li,_> <- block] | block <- duplicates });
}

/**
 * Filter a list of lrel[int, str] and return only the elements
 * of which the str part occurs multiple times in the list
 */
set[lrel[loc, int, str]] getDuplicates(list[lrel[loc f, int l, str c]] l)
{
	if(isEmpty(l)) 
		return [];
	
	set[lrel[loc, int, str]] duplicates = {};
	
	for(I <- [0..size(l)-1])
	{
		Head = l[I];
		Tail = l[I+1..];
		
		dupes = { x | x <- Tail, x.c == Head.c};
		if(!isEmpty(dupes))
			duplicates += {Head} + dupes;
	}
	return duplicates;
}
