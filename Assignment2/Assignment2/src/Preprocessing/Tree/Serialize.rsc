module Preprocessing::Tree::Serialize

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;

// General imports
import IO;
import List;
import Node;

// Custom data type to keep the nodes split
data DeclarationNode
	= \declarationAST(str name, int size, loc src)
	| \statementAST(str name, int size, loc src)
	| \expressionAST(str name, int size, loc src)
	| \typeAST(str name, int size); 

/**
 * This function turns an AST into a serialzed AST
 * @param the AST you want to serialize
 * @return the serialized AST
 */
public void Serialize(set[Declaration] ast)
{	
	// We serialize the AST by a preorder traversal
	list[DeclarationNode] nodes = [];
	
	top-down visit (ast) {
	case \Declaration d: 	nodes += declarationAST(getName(d), childrenSize(d), FixLoc(d));
	case \Statement s: 		nodes += statementAST(getName(s), childrenSize(s), s@src);
	case \Expression e: 	nodes += expressionAST(getName(e), childrenSize(e), FixLoc(e));
	case \Type t: 			nodes += typeAST(getName(t), childrenSize(t));
	}
	
	// Make suffix tree
	
}

/**
 * Obtains the name of the object
 * @param Node
 * @return amount of children
 */
 private int childrenSize(node n) {
 	count = -1;
 	
 	visit (n) {
	case \Declaration d: 	count += 1;
	case \Statement s: 		count += 1;
	case \Expression e: 	count += 1;
	case \Type t: 			count += 1;
	}
	
	return count;
 }
 
 /**
  * Function that fixes the source location
  * @param the node
  * @return the location
  */
 private loc FixLoc(node N) 
 {
	annotations = getAnnotations(N);
	if ("src" in annotations) {
		if (loc locationOfSource := annotations["src"])
			return locationOfSource;
	}
	return |file:///|;
 }