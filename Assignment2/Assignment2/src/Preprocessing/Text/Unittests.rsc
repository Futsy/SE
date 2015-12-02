module Preprocessing::Text::Unittests

// Model
import lang::java::jdt::m3::Core;

// General
import IO;
import List;
import util::Math;

// SUT
import Preprocessing::Text::Volume;

test bool NoComments()
{
	return linesInFile("Plain.java") == 38;
}

test bool SingleLineComments()
{
	return linesInFile("SingleLineComments.java") == 38;
}

test bool MultiLineComments()
{
	return linesInFile("MultiLineComments.java") == 38;
}

test bool MixedComments()
{
	return linesInFile("MixedComments.java") == 38;
}





int linesInFile(str fileName)
{
	model = createM3FromEclipseProject(|project://TestPreprocessing|);
	fileToLines = LinesOfCode(files(model));
	lines = [ *fileToLines[l] | l <- fileToLines, l.file == fileName];
	return size(lines);
}