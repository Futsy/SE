module complexity

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import String;

public map[int, int] CalculateComplexity(set[Declaration] tree)
{
	returnT = (0:0);
	// do something cool with
	//| \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
    //| \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions)
    
    //\todo:
    // Basically we iterate this AST
	// For each Method in the AST
		// check if we are: Constructor/Destructor/Assign/Func
			// if yes then check the Expressions and statement
				// create pair (SLOC Functor : Complexity of the Function)
				
	// something like this should work
	
    return returnT;
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
	case \for(_, _, _, _):	complexity += 1;
	case \do(_, _):			complexity += 1; // Not sure if this creates a branch
	case \while(_, _):		complexity += 1;
	case \try(_, _):		complexity += 1; //\todo: Not sure about these two
	case \try(_, _, _):		complexity += 1; //\todo: They should create branches right? or mayb
	}
	
	return complexity;
}

// Calculate the complexity for a given expression
public int Complexity(Expression expression)
{
	complexity = 1;
	
	visit (expression) { // There is always that one dude
	case conditional(_,_,_): complexity += 1;
	}
	
	return complexity;
}
