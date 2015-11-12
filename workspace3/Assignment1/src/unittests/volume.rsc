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
	lrel[loc l, str s] r = LinesOfCode(files(model));
	return size(r.s) == 38;
}

test bool testSingleClassComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingeClassComments|);
	lrel[loc l, str s] r = LinesOfCode(files(model));
	return size(r.s) == 38;
}

test bool testSingleClassSpecialComment()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeSingleClassSpecialComments|);
	lrel[loc l, str s] r = LinesOfCode(files(model));
	return size(r.s) == 38;
}

test bool testMultiClass()
{
	model = createM3FromEclipseProject(|project://JavaTestVolumeMultiClass|);
	lrel[loc l, str s] r = LinesOfCode(files(model));
	return size(r.s) == 2 * 38;
}