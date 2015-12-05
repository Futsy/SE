module Helpers::Types

// Aliases
alias lineMatrix = list[list[bool]];			// A matrix of lines in two files. A 'true' in a cell indicates that both lines have the same content
alias filePair = tuple[loc first,loc second];				
alias fileMatrix = map[filePair, lineMatrix];	// A matrix of lineMatrices. Contains a lineMatrix for each filePair in the project

alias fileLine = tuple[loc file, int lineNr];
alias dupLine = tuple[fileLine x, fileLine y];

alias t1Pair  = tuple[loc file, int s, int end];
alias t1clone = tuple[t1Pair x, t1Pair y];
alias t3clone = list[t1clone];

alias coord = tuple[int x, int y];