module LinesOfCode

import IO;

int LinesOfCode(loc location)
{
	return 0;
}

private list[str] code = ["int main()",
								"{",
								"	// this is a comment",
								" 	/* and here is", 
								" 	a multi-line comment */",
								" 	/* but the following */ int isAn = Expression;",
								" 	/* this is not */ */ an expression */",
								" 	/* and /* we /* should also handle this gracefully */",
								"}"];

int LinesOfCode(list[str] lines)
{
	inComment = false;
	for(line <- lines)
	{
		if(inComment)
		{
			println("");
		}
		else
		{
			println("");
		}
	}
	return 0;
}

public list[str] AllComments(M3 model)
{
	list[str] allComments = [];
	
	for (doc <- model@documentation) 
	{
		for (line <- readFileLines(doc.comments)) 
		{
			allComments += trim(line);
		}
	}
	return allComments;
}

