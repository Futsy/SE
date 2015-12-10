module MatchDetection::Text::RelationsTest

import MatchDetection::Text::Relations;

import List;
import Relation;
import Set;
import IO;
import analysis::graphs::Graph;
import String;

import Preprocessing::Text::Matrix;
	
private LineMatrix StringsToLineMat(list[str] lines) = 
		[[ c == "x" | c <- split(" ", line) ] | line <- lines];

test bool T1RelationCreationSimple()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - - - - - - -",
	"- x - - - - - - -",
	"- - x - - - - - -",
	"- - - x - - - - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - x - -",
	"- - - - - - - - -"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), false) ==
		{<<0,1>,<1,2>>,<<1,2>,<2,3>>,<<2,3>,<3,4>>,<<3,4>,<4,5>>,<<4,5>,<5,6>>,<<5,6>,<6,7>>};
}

test bool T1RelationCreationDirty()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - x x x x - -",
	"- x - - - - - - -",
	"- - x - - x x - -",
	"- - - x - - - - -",
	"- - x - x - x - -",
	"- x x - - x - - -",
	"- - - - - - x - -",
	"- - - x x x x - x"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), false) ==
		{<<0,1>,<1,2>>,<<1,2>,<2,3>>,<<2,3>,<3,4>>,<<3,4>,<4,5>>,<<4,5>,<5,6>>,<<5,6>,<6,7>>};
}

test bool T1RelationCreationMultiple()
{
	list[str] matrixAsString = [
	"- - x - - - - - -",
	"x - - x - - - - -",
	"- x - - x - - - -",
	"- - x - - x - - -",
	"- - - x - - x - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - x - -",
	"- - - - - - - - -"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), false) ==
		{<<0,1>,<1,2>>,<<1,2>,<2,3>>,<<2,3>,<3,4>>,<<3,4>,<4,5>>,<<4,5>,<5,6>>,<<5,6>,<6,7>>,
		<<2,0>,<3,1>>, <<3,1>,<4,2>>, <<4,2>,<5,3>>, <<5,3>,<6,4>>};
}

test bool T1RelationCreationMultipleDirty()
{
	list[str] matrixAsString = [
	"- x x - - x x x x",
	"x x - x - - - - -",
	"- x - - x - x x x",
	"- - x - - x - - -",
	"- x - x - - x - -",
	"- x - - x - x - x",
	"- x - x - x - - x",
	"- x - x - - x - x",
	"- x - x - - - - x"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), false) ==
		{<<0,1>,<1,2>>,<<1,2>,<2,3>>,<<2,3>,<3,4>>,<<3,4>,<4,5>>,<<4,5>,<5,6>>,<<5,6>,<6,7>>,
		<<2,0>,<3,1>>, <<3,1>,<4,2>>, <<4,2>,<5,3>>, <<5,3>,<6,4>>};
}

test bool T1RelationCreationOnlyDiagnoal()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- x - - - - - - -",
	"- - - - - - - - -"];
	
	b1 =  GetT1Relations(StringsToLineMat(matrixAsString), false) == {};
	
	matrixAsString = [
	"- - - - - - - - -",
	"- x x x x x x x -",
	"- - - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -"];
	
	b2 =  GetT1Relations(StringsToLineMat(matrixAsString), false) == {};
	
	return b1 && b2;
}

test bool T1RelationCreationOnlyTopToBottom()
{
	list[str] matrixAsString = [
	"- - - - - - - x -",
	"- - - - - - x - -",
	"- - - - - x - - -",
	"- - - - x - - - -",
	"- - - x - - - - -",
	"- - x - - - - - -",
	"- x - - - - - - -",
	"- - - - - - - - -",
	"- - - - - - - - -"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), false) == {};
}

test bool T1RelationCreationCrossFile()
{
	list[str] matrixAsString = [
	"x - - - - - - - -",
	"- x - x - - - - -",
	"- - x - x - - - -",
	"- x - x - x - - -",
	"- - x - x - x - -",
	"- - - x - x - x -",
	"- - - - x - x - x",
	"- - - - - x - x -",
	"- - - - - - - - x"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), true) ==
		{<<1,3>,<2,4>>,<<2,4>,<3,5>>,<<3,5>,<4,6>>,<<4,6>,<5,7>> };
}

test bool T1RelationCreationCrossFileDirty()
{
	list[str] matrixAsString = [
	"x - - x x x x x -",
	"- x - x -  - - -",
	"- - x - x - x x x",
	"- x - x - x - - -",
	"- - x - x - x - -",
	"- - - x - x - x -",
	"x x x - x - x - x",
	"- - - - - x - x -",
	"x x x x x x - - x"];
	
	return GetT1Relations(StringsToLineMat(matrixAsString), true) ==
		{<<1,3>,<2,4>>,<<2,4>,<3,5>>,<<3,5>,<4,6>>,<<4,6>,<5,7>> };
}

test bool T3SubRelationCreationExactMatch()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - - - - - - -",
	"- x - - - - - - -",
	"- - x - - - - - -",
	"- - - - - - - - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - x - -",
	"- - - - - - - - -"];
	
	crel t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);
	return GetT3SubRelation(t1rel, 3) == {<<0,1>,<2,3>>, <<4,5>,<6,7>>};
}

test bool T3SubRelationCreationNonExactMatch()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - - - - - - -",
	"- x - - - - - - -",
	"- - x - - - - - -",
	"- - - - - - - - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - x - -",
	"- - - - - - - - -"];
	
	crel t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);
	return GetT3SubRelation(t1rel, 2) == {<<0,1>,<1,2>>, <<1,2>,<2,3>>, <<4,5>,<5,6>>, <<5,6>,<6,7>>};
}

test bool T3SubRelationCreationNonExactMatchMulti()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - x - - - - -",
	"- x - - x - - - -",
	"- - x - - x - - -",
	"- - - - - - x - -",
	"- - - - x - - - -",
	"x - - - - x - - -",
	"- x - - - - x - -",
	"- - x - - - - x -"];
	
	crel t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);
	return GetT3SubRelation(t1rel, 3) == {
		<<0,1>,<2,3>>, 
		<<4,5>,<6,7>>,<<5,6>,<7,8>>,
		<<0,6>,<2,8>>, 
		<<3,1>,<5,3>>,<<4,2>,<6,4>>
		};
}
