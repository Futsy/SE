module unittests::coupling

import lang::java::jdt::m3::Core;
import coupling;

// General
import IO;

public test bool testCouplingNoMethodInvocation()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeMultiClass|);
	return coupling(model) == 100.0;	
}

public test bool testCouplingConcrete()
{
	model = createM3FromEclipseProject(|project://JavaTestCouplingConcrete|);
	return coupling(model) == 0.0;	
}

public test bool testCouplingInterface()
{
	model = createM3FromEclipseProject(|project://JavaTestCouplingInterface|);
	return coupling(model) == 1.0;	
}

public test bool testCouplingMixed()
{
	model = createM3FromEclipseProject(|project://JavaTestCouplingMixed|);
	return coupling(model) == 0.75;	
}