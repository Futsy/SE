module alt::duplication

import List;
import Set;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math; 
import String;
import volume;


public int CalculateDuplication(list[str] myList)
{
	minumumCloneLength = 6;
	indicesToCheck = [ x | x <- [0..size(myList)], x % minumumCloneLength == (minumumCloneLength-1)];
	
	sizeOfList = size(myList);
	
	list[tuple[int,int]] possibleCloneLines = [];
	
	for(I <- [1..size(myList)]) // we skip 0 since doing a mirror check does not make sense
	{
		possibleCloneLines = possibleCloneLines + [ <x, (x+I) % sizeOfList>  | x <- indicesToCheck, myList[x] == myList[(x+I) % sizeOfList]];
	}
	
	set[int] cloneLines = { *toSet(dupe(myList, l1, l2, minumumCloneLength)) | <l1,l2> <- possibleCloneLines};
		
	return size(cloneLines);
}

public list[int] dupe(list[str] l, int i1, int i2, int minDupeLength)
{	
	int startInx1 = i1 - (minDupeLength-1);
	int startInx2 = i2 - (minDupeLength-1);
	
	if(startInx1 < 0 || startInx2 < 0) return [];
	
	sizeOfList = size(l);
	
	int dupeLength = 0;
	
	while(startInx1 < sizeOfList && startInx2 < sizeOfList && startInx1 < (i1 + minDupeLength))
	{
		if(l[startInx1] == l[startInx2]) dupeLength = dupeLength + 1;
		else 
		{
			if( startInx1 > i1) break;
			else dupeLength = 0;
		}
		
		startInx1 = startInx1 + 1;
		startInx2 = startInx2 + 1;
	} 
	
	if(dupeLength >= minDupeLength)
	{
		return [startInx1-dupeLength .. startInx1] + [startInx2-dupeLength .. startInx2];
	}
	else
		return [];
	
}

// UNITTESTS
test bool testNoDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationNone|);
	l = LinesOfCode(files(model));
	result = toReal(CalculateDuplication(l)) / toReal(size(l)) * 100.0;
	//println(result);
	return result == 0.0;
}

test bool testSingleDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationSameClass6lines|);
	l = LinesOfCode(files(model));
	result = toReal(CalculateDuplication(l)) / toReal(size(l)) * 100.0;
	//println(result);
	return result == (2.0 / 3.0) * 100.0;
}

test bool testSingleLargerDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationSameClass10lines|);
	l = LinesOfCode(files(model));
	result = toReal(CalculateDuplication(l)) / toReal(size(l)) * 100.0;
	//println(result);
	return result == (20.0 / 26.0) * 100.0;
}

test bool testMultiDuplication()
{
	model = createM3FromEclipseProject(|project://JavaTestDuplicationMultiClass|);
	l = LinesOfCode(files(model));
	result = toReal(CalculateDuplication(l)) / toReal(size(l)) * 100.0;
	//println(result);
	return result == (3*10.0) / (25.0 + 39.0 + 51.0) * 100.0;
}