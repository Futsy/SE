module clones

import List;
import IO;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::Math; 
import String;
import util::Benchmark;

import volume;

//public int dupeLength(list[str] l, int i1, int i2)
//{
//	//println("DupeLength: \n\t<l[i1..] + l[..i1]>\n\t<l[i2..] + l[..i2]>");
//	//return size(dupe(l[i1..] + l[..i1], l[i2..] + l[..i2]));
//	tmp = dupe2(l, i1, i2, 6);
//	println(tmp);
//	return size(tmp);
//}
//
//public list[str] dupe(list[str] l, list[str] r)
//{
//	maxCloneLength = min(size(l), size(r));
//	
//	int end = 0;
//	while(maxCloneLength > i && l[i] == r[i])
//	{
//		end = end+1;
//	}
//	return l[..i];
//}

void RunBenchMarkDupe()
{
	//model = createM3FromEclipseProject(|project://MyTestJava|);
	//model = createM3FromEclipseProject(|project://smallsql0.21_src|);
	model = createM3FromEclipseProject(|project://hsqldb-2.3.1|);
	//model = createM3FromEclipseFile(|project://MyTestJava/src/testCloneDetection/A.java|);
	
	lines = GetProjectLines_int({file | file <- model@containment.from, file.scheme == "java+compilationUnit"}, model@documentation.comments);
	
	println(benchmark((			
		"Bouke" : void() {getDuplicateLines(lines);},
		"Floris" : void() {CalculateDuplication(lines);}
		)));
}

public list[int] dupe(list[str] l, int i1, int i2, int minDupeLength)
{
	//println("DupeLength <i1> <i2> <size(l)>");//: \n\t<l[i1]>\n\t<l[i2]>");
	int startInx1 = min(0,i1 - minDupeLength);
	int startInx2 = min(0,i2 - minDupeLength);
	
	sizeOfList = size(l);
	
	int dupeLength = 0;
	
	while(startInx1 < sizeOfList && startInx2 < sizeOfList)
	{
		if(l[startInx1] == l[startInx2]) dupeLength = dupeLength + 1;
		else if( startInx1 > i1) break;
		
		startInx1 = startInx1 + 1;
		startInx2 = startInx2 + 1;
	} 
	
	if(dupeLength >= minDupeLength)
		return [startInx1-dupeLength .. startInx1] + [startInx2-dupeLength .. startInx2];
	else
		return [];
	
}

public set[int] getDuplicateLines(list[str] myList)
{
	// TODO: we can count back instead of fwd becasue bla[-1] is allowed. That saves us the % sizeofList

	//  [*readFileLines(files) | files <- createM3FromEclipseProject(|project://smallsql0.21_src|)@containment.from, files.scheme == "java+compilationUnit" ]
	//myList = [ trim(x) | x <- GetProjectLines(createM3FromEclipseProject(|project://smallsql0.21_src|))];
	//myList = [ trim(x) | x <- GetProjectLines(createM3FromEclipseProject(|project://MyTestJava|))];
	
	// let's see how long it takes to do 200000 string compares
	minumumCloneLength = 6;
	indicesToCheck = [ x | x <- [0..size(myList)], x % minumumCloneLength == 0];
	
	//println(myList);
	//println(indicesToCheck);
	
	//for(I <- [0..size(myList)])
	//{
	//	println("<I>:\t<myList[I]>");
	//}
	
	sizeOfList = size(myList);
	
	list[tuple[int,int]] possibleCloneLines = [];
	//list[int] cloneLengths = [];
	
	
	for(I <- [1..size(myList)]) // we skip 0 since doing a mirror check does not make sense
	{
		//possibleCloneLines = possibleCloneLines +  [ <I,x+i,myList[I]>  | x <- indicesToCheck, myList[I] == myList[(x+I) % sizeOfList]];
		possibleCloneLines = possibleCloneLines + [ <x, (x+I) % sizeOfList>  | x <- indicesToCheck, myList[x] == myList[(x+I) % sizeOfList]];
		//println(boolList);
	}
	
	set[int] cloneLines = { *toSet(dupe(myList, l1, l2, minumumCloneLength)) | <l1,l2> <- possibleCloneLines};
	
	//println(possibleCloneLines);
	println(cloneLines);
	
	return cloneLines;
	
	//println( [ myList[x] == myList[(x+1) % size(myList)] | x <- [0..size(myList)]] );
}

int CalculateDuplication(list[str] lines)
{
	// Possible roblems here:
	// -> 6 dupe will be matched as multiple 6 line dupes
	// -> The dup will remove all duplicates, so we no longer know how often the dupe occurred 
	
	// Upside: significantly faster than mine
	// ("Bouke":92071,"Floris":16871) on smallsql
	
	// A group of 6 lines that appears (without alterations) in more than one place is a duplicate
	allBlocksOf6 = [take(6, lines[block..]) | block <- [0..size(lines) - 6]];
	return size(sort(allBlocksOf6) - sort(dup(allBlocksOf6))); 
}