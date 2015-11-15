module coupling

import lang::java::jdt::m3::Core;
import IO;
import util::Math;
import Relation;
import List;

/** 
 * Generate a coupling metric by calculating the how many if the method calls to classes
 * which are part of the project, are calls to interfaces and how many are calls to 
 * concrete classes
 */
public real coupling(M3 model)
{
	localMethodCalls = getAllLocalMethodCalls(model);
	
	// Filter out all local method calls to interfaces
	// Note that the all construct should not be funcitonally necessary as domain should always return a singleton list
	// (a method cannot be part of multiple classes)
	callsToInterface = [method | method <- localMethodCalls, all( 
		containingClass <- domain(rangeR(model@containment, {method})), 
		containingClass.scheme == "java+interface")
	]; 
	
	// If we don't have any method calls, we have pretty loose coupling
	if(isEmpty(localMethodCalls)) 
		return 100.0;
	
	// If we don't have any method calls to interfaces, we have pretty tight coupling
	if(isEmpty(callsToInterface)) 
		return 0.0;
	
	return toReal(size(callsToInterface)) / toReal(size(localMethodCalls));
}

/**
 * Return all the methods
 */
private list[loc] getAllLocalMethodCalls(M3 model)
{
	// Get all the method calls from the project
	methodCalls = [m.to | m <-model@methodInvocation];
	
	// Get all the methods defined in the project
	methodsInProject = [ e | e <- model@containment.to, e.scheme == "java+method"];
	
	// The intersection of both are the method calls to methods local to the project
	// Note that we do not use sets as we want to keep multiples
	return methodCalls & methodsInProject;
}