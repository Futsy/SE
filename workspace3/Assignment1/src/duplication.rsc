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

public int CalculateDuplication(list[str] lines, M3 model)
{
	// A group of 6 lines that appears (without alterations) in more than one place is a duplicate
	allBlocksOf6 = [take(6, lines[block..]) | block <- [0..size(lines) - 6]];
	return size(sort(allBlocksOf6) - sort(dup(allBlocksOf6))); 
}
