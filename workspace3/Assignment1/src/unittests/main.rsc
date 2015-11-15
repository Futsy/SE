module unittests::main

// General
import IO;
import List;

import main;

test bool TestClassToStr(int class)
{
	switch (ClassToStr(class)) {
	case "--": return class == 0;
	case "-":  return class == 1;
	case "o":  return class == 2;
	case "+":  return class == 3;
	case "++": return class == 4;
	default: return class notin [0..5];
	}
}

test bool TestReportDuplications(int sloc, int duplications)
{
	try return ReportDuplications(sloc, duplications) in [0..5];
	catch: return sloc <= 0 || duplications <= 0;
}

test bool TestReportComplexity(int sloc, lrel[int, int] complexity)
{
	try return ReportComplexity(sloc, complexity) in [0..5];
	catch: return sloc <= 0 || size(complexity) == 0;
}

test bool TestReportUnitSize(lrel[int complexity, int methodSloc] complexity)
{
	try return ReportUnitSize(complexity) in [0..5];
	catch: return size(complexity) == 0 || sum(complexity.methodSloc) == 0;
}

test bool TestReportVolume(int sloc)
{
	return ReportVolume(sloc) in [0..5];
}
