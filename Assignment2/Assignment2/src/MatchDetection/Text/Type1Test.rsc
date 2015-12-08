module MatchDetection::Text::Type1Test

// Model
import lang::java::jdt::m3::Core;

// General imports
import IO;
import List;

// Project imports
import Preprocessing::Text::Volume;
import Matrix;
import Diagonal;
import util::Math;

// SUT
import MatchDetection::Text::Type1;

// Aliases of t1 clones for testing. Use only the filename instead of the complete location for portability
alias t1TestPair  = tuple[str file, int s, int end];
alias t1Testclone = tuple[t1TestPair x, t1TestPair y];

test bool SingleFileSingleClone()
{
	clones = GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 7);
	return size(clones) == 0;
}

test bool SingleFileSineCloneRepeated()
{
	clones = GetClonesInProject(|project://TestClonesSingleFileSingleCloneRepeated|, 6);
		
	if (!CheckClones(clones, [
		<<"ClassA.java", 39, 44>,<"ClassA.java", 24,29>>,
		<<"ClassA.java", 39, 44>,<"ClassA.java", 7,12>>,
		<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>
		]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesSingleFileSingleCloneRepeated|, 7);
	return size(clones) == 0;
}

test bool SingleFileMultiClone()
{
	clones = GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>]))
		return false;
		
	clones = GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 4);
	if (!CheckClones(clones, [
		<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>,
		<<"ClassA.java", 47, 50>,<"ClassA.java", 39,42>>
		]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 7);
	return size(clones) == 0;
}

test bool MultiFileSingleClone()
{
	clones = GetClonesInProject(|project://TestClonesMultiFileSingleClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassB.java", 8, 13>,<"ClassA.java", 7,12>>]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesMultiFileSingleClone|, 7);
	return size(clones) == 0;
}

test bool MultiFileSingleCloneRepeated()
{
	clones = GetClonesInProject(|project://TestClonesMultiFileSingleCloneRepeated|, 6);
	
	if (!CheckClones(clones, [
		// Function body of Foo is copied in Bar in file ClassA.java
		<<"ClassA.java", 3, 10>,<"ClassA.java", 12,19>>,
		// Function body of Foo is copied in Bar in file ClassB.java
		<<"ClassB.java", 3, 10>,<"ClassB.java", 12,19>>,
		// Function body of Foo is copied in Car in file ClassB.java
		<<"ClassB.java", 3, 10>,<"ClassB.java", 21,28>>,
		// Function body of Bar is copied in Car in file ClassB.java
		<<"ClassB.java", 12,19>,<"ClassB.java", 21,28>>,
		// Body of Foo and whole Car in ClassA.java is copied in body of Bar and whole of Car in ClassB.java
		<<"ClassA.java", 3, 20>,<"ClassB.java", 12,29>>,
		// Foo in ClassA.java is copied in Foo in ClassB.java
		<<"ClassA.java", 2, 10>,<"ClassB.java", 2,10>>,
		// Body of Foo in ClassA.java is copied in body of Car in ClassB.java
		<<"ClassA.java", 3, 10>,<"ClassB.java", 21,28>>,
		// Body of Car in ClassA.java is copied in body of Foo in ClassB.java
		<<"ClassA.java", 12, 19>,<"ClassB.java", 3,10>>,
		// Body of Car in ClassA.java is copied in body of Bar in ClassB.java
		<<"ClassA.java", 12, 19>,<"ClassB.java", 12,19>>
		]))
		return false;

	return true;
}

private bool CheckClones(list[t1clone] detectedClones, list[t1Testclone] expectedClones)
{
	// Conver the clone type to "test" clone types
	detectedClones = [ <<f1.file, s1, e1>,<f2.file, s2, e2>> | <<f1, s1, e1>,<f2, s2, e2>> <- detectedClones];
	
	/* A clone is represented as a tuple, but should really be an unordered pair
	 * To prevent the caller of this function from having to know in which order the detection
	 * algorithm puts the two parts of the clone, invert expected clones and add it to itsef
	 */
	expectedClonesInverted = [ <y,x> | <x,y> <- expectedClones];
	detectedClonesInverted = [ <y,x> | <x,y> <- detectedClones];

	if(size(detectedClones) != size(expectedClones))
	{
		println("Wrong number of clones: <size(detectedClones)>. Expected <size(expectedClones)>");
		return false;
	}
	
	notExpected = detectedClones - (expectedClones + expectedClonesInverted);
	notDetected = expectedClones - (detectedClones + detectedClonesInverted);
	
	if(notExpected != [])
		println("The following clones were detected but not expected: <notExpected>");
		
	if(notDetected != [])
		println("The following clones were expected but not detected: <notDetected>");
	
	return notExpected == [] && notDetected == [];
}

public list[t1clone] GetClonesInProject(loc project, int threshold)
{
	set[loc] files = files(createM3FromEclipseProject(project));
	
	// Create a comparison map from file to file giving a matrix of duplications (bools)
	fileMatrix matrix = CreateFileMatrix(LinesOfCode(files));
	
	// Now we obtain the diagonals from the matrices
	Diagonals diagonals = CheckDiagonals(matrix);
	
	return GetT1Clone(threshold, diagonals);
}

public int GetCloneSize(t1clone clone)
{
	return clone.x.end - clone.x.s + 1;
}