module unittests::duplication

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import util::Math;

// SUT
import duplication;
import volume;

test bool testNoDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationNone|);
	l = LinesOfCode(files(model));
	result =  toReal(CalculateDuplication(l, model)) / toReal(size(l)) * 100.0;
	println(result);
	return result == 0.0;
}

test bool testSingleDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationSameClass6lines|);
	l = LinesOfCode(files(model));
	result =  toReal(CalculateDuplication(l, model)) / toReal(size(l)) * 100.0;
	println(result);
	return result == (2.0 / 3.0) * 100.0;
}

test bool testSingleLargerDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationSameClass10lines|);
	l = LinesOfCode(files(model));
	result =  toReal(CalculateDuplication(l, model)) / toReal(size(l)) * 100.0;
	println(result);
	return result == (20.0 / 26.0) * 100.0;
}

test bool testMultiDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationMultiClass|);
	l = LinesOfCode(files(model));
	result =  percentageDuplicated(l);
	//println(result);
	return result == (3*10.0) / (25.0 + 39.0 + 51.0) * 100.0;
}