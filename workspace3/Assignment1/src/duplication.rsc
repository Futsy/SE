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

public int CalculateDuplication(list[str] l)
{
	// Insert line numbers
	lrel[int, str] lines = [<I, l[I]> | I <- [0..size(l)]];
	
	// A group of 6 lines that appears (without alterations) in more than one place is a duplicate
	allBlocksOf6 = [take(6, lines[block..]) | block <- [0..size(lines) - 6]];
	
	set[lrel[int line, str content]] duplicates = getDuplicates(allBlocksOf6);
	return size({ *dupe.line | dupe <- duplicates });  
}

// filter a list of lrel[int, str] and return only the elements
// of which the str part occurs multiple times in the list
set[lrel[int, str]] getDuplicates(list[lrel[int l, str c]] l)
{
	if(isEmpty(l)) return [];
	
	set[lrel[int, str]] duplicates = {};
	
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
