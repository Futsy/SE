module complexity

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import Set;
import String;

import volume;

public lrel[str methodName, int complexity, int methodSloc] CalculateComplexity(set[Declaration] tree)
{
	returnList = [];
	
	//\todo: I strongly dislike the sum here
	
	// Basically we iterate this AST
	visit (tree) {
	case method(_, str name, _, list[Expression] exceptions, Statement impl):
		returnList += <
			name, 
			Complexity(impl) + sum([0] + [Complexity(except) | except <- exceptions]),
			size(LinesOfCode({impl@src}))
		>;
	case constructor(str name, _, list[Expression] exceptions, Statement impl): 
		returnList += <
			name, 
			Complexity(impl) + sum([0] + [Complexity(except) | except <- exceptions]),
			size(LinesOfCode({impl@src}))
		>;
	}

	return returnList;
}


// Calculate the complexity for a given statement
public int Complexity(Statement statement) 
{
	complexity = 1;
	
	// Check every statement that creates a branch
	visit (statement) { //\todo: No fall through T_T I feel stupid typing this
	case \if(_, _):			complexity += 1;
	case \if(_, _, _):		complexity += 1;
	case \for(_, _, _):		complexity += 1;
	case \for(_, _, _, _):		complexity += 1;
	case \do(_, _):			complexity += 1; // Not sure if this creates a branch
	case \while(_, _):		complexity += 1;
	case \try(_, _):		complexity += 1; //\todo: Not sure about these two
	case \try(_, _, _):		complexity += 1; //\todo: They should create branches right? or maybe finally or catch?
	}
	
	return complexity;
}

// Calculate the complexity for a given expression
public int Complexity(Expression expression)
{
	complexity = 0;
	
	visit (expression) { // There is always that one dude
	case conditional(_,_,_): complexity += 1;
	}
	
	return complexity;
}
