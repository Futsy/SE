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

test bool SingleFileSingleClone()
{
	clones = GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 6);
	
	if (!CheckClones(clones, [6]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesSingleFileSingleClone|, 7);
	return size(clones) == 0;
}

test bool SingleFileMultiClone()
{
	clones = GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 6);
	
	// There should be three clones
	if(!CheckClones(clones, [6,6,6]))
		return false;
	
	// Verify that we have no clones if the threshold is too high
	clones =  GetClonesInProject(|project://TestClonesSingleFileMultiClone|, 7);
	return size(clones) == 0;
}

private bool CheckClones(list[t1clone] clones, list[int] expectedCloneLengths)
{
	if(size(clones) != size(expectedCloneLengths))
	{
		println("Wrong number of clones: <size(clones)>. Expected <size(expectedCloneLengths)>");
		return false;
	}
	
	for(I <- [0..size(clones)])
	{
		if(GetCloneSize(clones[I]) != expectedCloneLengths[I])
		{
			println("Length of clone <I+1> (<size(clones[I])>) does not match expected clone length (<expectedCloneLengths[I]>)");
			return false;
		}
	}
	
	return true;
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