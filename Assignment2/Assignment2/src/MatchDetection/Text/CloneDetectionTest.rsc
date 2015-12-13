module MatchDetection::Text::CloneDetectionTest

// Model
import lang::java::jdt::m3::Core;

// General imports
import IO;
import List;

// Project imports
import Preprocessing::Text::Volume;
import Preprocessing::Text::Matrix;
import util::Math;

// SUT
import MatchDetection::Text::CloneDetection;

// Aliases of t1 clones for testing. Use only the filename instead of the complete location for portability
alias t1TestPair  = tuple[str file, int s, int end];
alias t1Testclone = tuple[t1TestPair x, t1TestPair y];

test bool T1SingleFileSingleClone()
{
	<clones, _> = GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	<clones, _> =  GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 8);
	return size(clones) == 0;
}

test bool T1SingleFileSineCloneRepeated()
{
	<clones, _> = GetClonesInProject(|project://TestClonesSingleFileSingleCloneRepeated|, 6);
		
	if (!CheckClones(clones, [
		<<"ClassA.java", 39, 44>,<"ClassA.java", 24,29>>,
		<<"ClassA.java", 39, 44>,<"ClassA.java", 7,12>>,
		<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>
		]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	<clones, _> =  GetClonesInProject(|project://TestClonesSingleFileSingleCloneRepeated|, 7);
	return size(clones) == 0;
}

test bool T1SingleFileMultiClone()
{
	<clones, _> = GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>]))
		return false;
		
	<clones, _> = GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 4);
	if (!CheckClones(clones, [
		<<"ClassA.java", 24, 29>,<"ClassA.java", 7,12>>,
		<<"ClassA.java", 34, 37>,<"ClassA.java", 39,42>>
		]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	<clones, _> =  GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 7);
	return size(clones) == 0;
}

test bool T1MultiFileSingleClone()
{
	<clones, _> = GetClonesInProject(|project://TestClonesMultiFileSingleClone|, 6);
	
	if (!CheckClones(clones, [<<"ClassB.java", 8, 13>,<"ClassA.java", 7,12>>]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	<clones, _> =  GetClonesInProject(|project://TestClonesMultiFileSingleClone|, 7);
	return size(clones) == 0;
}

test bool T1MultiFileSingleCloneRepeated()
{
	<clones, _> = GetClonesInProject(|project://TestClonesMultiFileSingleCloneRepeated|, 6);
	
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

test bool T3SingleFileSingleCloneAddition()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileSingleCloneAddition|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the addition)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 19>,<"ClassA.java", 29,43>>,
		<<"ClassA.java", 20, 27>,<"ClassA.java", 47,54>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 27>,<"ClassA.java", 29,54>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileSingleCloneDeletion()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileSingleCloneDeletion|, 6, 4, 4);

	// There should be two t1 clones (seperated by the deletion)
	
		if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassA.java", 27,37>>,
		<<"ClassA.java", 16, 25>,<"ClassA.java", 40,49>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 25>,<"ClassA.java", 27,49>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileSingleCloneChange()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileSingleCloneChange|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 14>,<"ClassA.java", 29,38>>,
		<<"ClassA.java", 18, 27>,<"ClassA.java", 42,51>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 27>,<"ClassA.java", 29,51>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileSingleCloneChangeAddition()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileSingleCloneChangeAddition|, 6, 4, 4);

	// There should be two t1 clones (seperated by the addition & change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassA.java", 30,40>>,
		<<"ClassA.java", 18, 28>,<"ClassA.java", 42,52>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 28>,<"ClassA.java", 30,52>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileSingleCloneChangeDeletion()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileSingleCloneChangeDeletion|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the deletion & change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassA.java", 28,38>>,
		<<"ClassA.java", 17, 26>,<"ClassA.java", 41,50>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 26>,<"ClassA.java", 28,50>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileMultiClone()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileMultiClone|, 6, 4, 7);
	
	if (!CheckClones(t3clones, [
		// match on the clone we inserted, see it as a deletion of the code that was there before
		<<"ClassA.java", 5, 19>,<"ClassA.java", 29,50>>,
		// Match on the second clone, see the text before as a change
		<<"ClassA.java", 5, 27>,<"ClassA.java", 29,51>>
		]))
		return false;
	
	return true;
}

test bool T3SingleFileMultiCloneChained()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3SingleFileMultiCloneChained|, 4, 4, 3);
	
	// We should have 4 t1 clones
	if (!CheckClones(t1clones, [
		// Clone before insertion
		<<"ClassA.java", 5, 12>,<"ClassA.java", 30,37>>,
		// Clone before removal
		<<"ClassA.java", 16, 19>,<"ClassA.java", 38,41>>,
		// Clone before change
		<<"ClassA.java", 20, 23>,<"ClassA.java", 44,47>>,
		// Clone after removal
		<<"ClassA.java", 25, 28>,<"ClassA.java", 49,52>>
		]))
		return false;
	
	// There is one t3 clone that encompasses all of these t1 clones
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 28>,<"ClassA.java", 30,52>>
		]))
		return false;
	
	
	return true;
}

test bool T3MultiFileSingleCloneAddition()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3MultiFileSingleCloneAddition|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the addition)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 19>,<"ClassB.java", 5,19>>,
		<<"ClassA.java", 20, 28>,<"ClassB.java", 23,31>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 28>,<"ClassB.java", 5,31>>
		]))
		return false;

	return true;
}

test bool T3MultiFileSingleCloneDeletion()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3MultiFileSingleCloneDeletion|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the deletion)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassB.java", 5,15>>,
		<<"ClassA.java", 16, 26>,<"ClassB.java", 18,28>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 26>,<"ClassB.java", 5,28>>
		]))
		return false;

	return true;
}

test bool T3MultiFileSingleCloneChange()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3MultiFileSingleCloneChange|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 14>,<"ClassB.java", 5,14>>,
		<<"ClassA.java", 18, 28>,<"ClassB.java", 18,28>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 28>,<"ClassB.java", 5,28>>
		]))
		return false;

	return true;
}

test bool T3MultiFileSingleCloneChangeAddition()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3MultiFileSingleCloneChangeAddition|, 6, 4, 4);

	// There should be two t1 clones (seperated by the addition & change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassB.java", 5,15>>,
		<<"ClassA.java", 18, 29>,<"ClassB.java", 17,28>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 29>,<"ClassB.java", 5,28>>
		]))
		return false;
	
	return true;
}

test bool T3MultiFileSingleCloneChangeDeletion()
{
	<t1clones, t3clones> = GetClonesInProject(|project://TestT3MultiFileSingleCloneChangeDeletion|, 6, 4, 4);
	
	// There should be two t1 clones (seperated by the deletion & change)
	if (!CheckClones(t1clones, [
		<<"ClassA.java", 5, 15>,<"ClassB.java", 5,15>>,
		<<"ClassA.java", 17, 27>,<"ClassB.java", 18,28>>
		]))
		return false;
		
	// And one t3 clone 
	if (!CheckClones(t3clones, [
		<<"ClassA.java", 5, 27>,<"ClassB.java", 5,28>>
		]))
		return false;
	
	return true;
}



private bool CheckClones(list[clone] detectedClones, list[t1Testclone] expectedClones)
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

public tuple[list[clone], list[clone]] GetClonesInProject(loc project, int t1threshold) = 
	GetClonesInProject(project, t1threshold, 50, 0);
	
public tuple[list[clone], list[clone]] GetClonesInProject(loc project, int t1threshold, int t3MinSubLength, int t3MaxHole)
{
	set[loc] files = files(createM3FromEclipseProject(project));
	
	// Process all source lines
	sourceLines = LinesOfCode(files);
	
	// Make a list of file pair to compare:
	list[tuple[loc x, loc y]] filesToCompare = [];
	for(f1 <- files)
	{
		for(f2 <- files)
		{
			if (<f2,f1> notin filesToCompare)
				filesToCompare += <f1,f2>;
		}
	}
	
	t1clones = [];
	t3clones = [];
	
	for(filePair <- filesToCompare)
	{
		// Create Matrix for this filepair
		mat = CreateLineMatrix(sourceLines[filePair.x], sourceLines[filePair.y]);

		// Get clones 
		<t1clonesTmp, t3clonesTmp> = GetClones(filePair, mat, t1threshold, t3MinSubLength, t3MaxHole);
		
		// Add them to list
		t1clones += t1clonesTmp;
		t3clones += t3clonesTmp;
	}
	
	return <t1clones, t3clones>;
}

public int GetCloneSize(clone clone)
{
	return clone.x.end - clone.x.s + 1;
}