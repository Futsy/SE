module Helpers::Print

import IO;
import List;
import Helpers::Types;

public void PrintT1Clones(list[t1clone] t1clones)
{
	for(c <- t1clones)
	{
		println("<c.x.file.file> [<c.x.s>..<c.x.end>] - <c.y.file.file> [<c.y.s>..<c.y.end>]");
	}
}

public void printMatrix(fileMatrix matrix)
{
	for(fp <- matrix)
	{
		println("<fp.first.file> vs <fp.second.file>");
		for (row <- matrix[fp]) 
		{
			str output = "";
			for (col <- row) 
			{
				output += col ? "*" : "-";
			}
			println(output);
		}
	}		
}