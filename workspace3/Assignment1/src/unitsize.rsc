module unitsize

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import String;

// Get all the Java methods
public set[loc] AllMethods(M3 model) 
	= {method | method <- model@containment.from, method.scheme == "java+method"};
