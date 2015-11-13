module complexity

// AST
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import List;

import volume;

public lrel[int complexity, int methodSloc] CalculateComplexity(set[Declaration] tree)
{
	returnList = [];
	
	// Basically we iterate this AST
	visit (tree) {
	case Declaration dec : method(_, _, _, _, Statement impl):
		returnList += <Complexity(dec), size(LinesOfCode({impl@src}))>;
	case Declaration dec : constructor(_, _, _, Statement impl): 
		returnList += <Complexity(dec), size(LinesOfCode({impl@src}))>;
	}

	return returnList;
}

// Calculate the complexity for a given declaration
public int Complexity(Declaration declaration) 
{
	complexity = 1;
	
	// Check every statement that creates a branch
	visit (declaration) {
	case \if(_, _):			complexity += 1;
	case \if(_, _, _):		complexity += 1;
	case \for(_, _, _):		complexity += 1;
	case \for(_, _, _, _):	complexity += 1;
	case \foreach(_, _, _):	complexity += 1;
	case \do(_, _):			complexity += 1;
	case \while(_, _):		complexity += 1;
	case \catch(_, _):		complexity += 1;
	case \case(_):			complexity += 1;
	
	// All the expressions
	case conditional(_,_,_): 									
							complexity += 1;
	case \infix(_, "||", _, list[Expression] subExpressions): 	
							complexity += 1 + size(subExpressions);
    case \infix(_, "&&", _, list[Expression] subExpressions): 	
    						complexity += 1 + size(subExpressions);
	}
	
	return complexity;
}
