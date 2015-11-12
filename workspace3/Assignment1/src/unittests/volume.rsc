module unittests::volume

// Model
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import util::Math;

// SUT
import volume;

test bool testSingleClassClean()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassClean|);
	return size(LinesOfCode(files(model))) == 38;
}

test bool testSingleClassComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassComments|);
	return size(LinesOfCode(files(model))) == 38;
}

test bool testSingleClassSpecialComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingleClassSpecialComments|);
	return size(LinesOfCode(files(model))) == 38;
}

test bool testMultiClass()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeMultiClass|);
	return size(LinesOfCode(files(model))) == 2 * 38;
}