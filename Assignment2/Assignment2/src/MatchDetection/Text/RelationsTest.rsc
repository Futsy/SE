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

test bool T3RelationCreationNoT3()
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
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	t3rel = GetT3Relations(t1rel,3, 2);
	
	
	return GetT3Clones(t3rel, t1rel) == {};
}

test bool T3RelationCreationSingleT3Diagonal()
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
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	
	// Minimum t3 sub-clone size = 3 and max hole =1. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 1);	
	valid1 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<6,7>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =2. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 2);	
	valid2 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<6,7>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =0. This should give no clones
	t3rel = GetT3Relations(t1rel,3, 0);	
	valid3 =  GetT3Clones(t3rel, t1rel) == {};
	
	// Minimum t3 sub-clone size = 4 and max hole = 1. This should give no clones
	t3rel = GetT3Relations(t1rel,4, 1);	
	valid4 =  GetT3Clones(t3rel, t1rel) == {};
	
	return valid1 && valid2 && valid3 && valid4;
}

test bool T3RelationCreationSingleT3Horizontal()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - - - - - - -",
	"- x - - - - - - -",
	"- - x - - - - - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - x - -",
	"- - - - - - - - -",
	"- - - - - - - - -"];
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	
	// Minimum t3 sub-clone size = 3 and max hole =1. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 1);	
	valid1 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<6,6>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =2. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 2);	
	valid2 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<6,6>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =0. This should give no clones
	t3rel = GetT3Relations(t1rel,3, 0);	
	valid3 =  GetT3Clones(t3rel, t1rel) == {};
	
	// Minimum t3 sub-clone size = 4 and max hole = 1. This should give no clones
	t3rel = GetT3Relations(t1rel,4, 1);	
	valid4 =  GetT3Clones(t3rel, t1rel) == {};
	
	return valid1 && valid2 && valid3 && valid4;
}

test bool T3RelationCreationSingleT3Vertial()
{
	list[str] matrixAsString = [
	"- - - - - - - - -",
	"x - - - - - - - -",
	"- x - - - - - - -",
	"- - x - - - - - -",
	"- - - - - - - - -",
	"- - - x - - - - -",
	"- - - - x - - - -",
	"- - - - - x - - -",
	"- - - - - - - - -"];
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	
	// Minimum t3 sub-clone size = 3 and max hole =1. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 1);	
	valid1 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<5,7>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =2. This should give one t3 clone
	t3rel = GetT3Relations(t1rel,3, 2);	
	valid2 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<5,7>>};
	
	// Minimum t3 sub-clone size = 3 and max hole =0. This should give no clones
	t3rel = GetT3Relations(t1rel,3, 0);	
	valid3 =  GetT3Clones(t3rel, t1rel) == {};
	
	// Minimum t3 sub-clone size = 4 and max hole = 1. This should give no clones
	t3rel = GetT3Relations(t1rel,4, 1);	
	valid4 =  GetT3Clones(t3rel, t1rel) == {};
	
	return valid1 && valid2 && valid3 && valid4;
}

test bool T3RelationCreationMiltipleT3()
{
	list[str] matrixAsString = [
	"- - - - - - - - - -",
	"x - - - - - - - - -",
	"- x - - - - - - - -",
	"- - x - - - - - - -",
	"- - - - - - - x - -",
	"- - - - - - - - x -",
	"- - - - - x - - - x",
	"- - - x - - x - - -",
	"- - - - x - - x - -",
	"- - - - - x - - - -"];
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	
	// maximum hole = 1 --> No t3 clones
	t3rel = GetT3Relations(t1rel,3, 1);	
	valid1 =  GetT3Clones(t3rel, t1rel) == {};
		
	// maximum hole = 2 --> 
	// subCloneStart -> subClonediagnoal
	t3rel = GetT3Relations(t1rel,3, 2);	
	valid2 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<7,8>>};
	
	// maximum hole = 3 --> 
	// subCloneStart -> subCloneVertical + subCloneStart -> subClonediagnoal
	t3rel = GetT3Relations(t1rel,3, 3);	
	valid3 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<5,9>>, <<0,1>,<7,8>>};
	
	// maximum hole = 4 --> 
	// subCloneStart -> subCloneVertical + subCloneStart -> subClonediagnoal + subCloneStart -> subClonediagnoal
	t3rel = GetT3Relations(t1rel,3, 4);	
	valid4 =  GetT3Clones(t3rel, t1rel) == {<<0,1>,<5,9>>, <<0,1>,<7,8>>, <<0,1>,<9,6>>};
	
	return valid1 && valid2 && valid3 && valid4;
}

test bool T3RelationSingleChainedT3()
{
	list[str] matrixAsString = [
	"x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - x - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - x - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - - x - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - - - x - - - - - - - - -"
	];
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	t3rel = GetT3Relations(t1rel,2, 4);	
	
	return  GetT3Clones(t3rel, t1rel) == {<<0,0>,<27,17>>};	
}

test bool T3RelationMultipleChainedT3()
{
	list[str] matrixAsString = [
	"x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - x - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - x - - - - x - - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - x - - - - x - - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - x - - - - x - - - - - - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - - - - - - - - - x - - - - - - - - - - - - - - - - - -",
	"- - - - - - - - - - x - - - - - - - - x - - - - - - - - - - - - - - - - -",
	"- - - - - - - - x - - x - - - - - - - - x - - - - - - - - - - - - - - - -",
	"- - - - - - - - - x - - x - - - - - - - - - - - - x - - - - - - - - - - -",
	"- - - - - - - - - - x - - x - - - - - - - - - - - - x - - - - - - - - - -",
	"- - - - - - - - - - - x - - - - - - - - - - - - - - - x - - - - - - - - -"
	];
	
	t1rel = GetT1Relations(StringsToLineMat(matrixAsString), false);	
	t3rel = GetT3Relations(t1rel,2, 4);	
	
	return  GetT3Clones(t3rel, t1rel) == {<<0,0>,<27,17>>, <<0,0>,<11,17>>, <<0,0>,<13,16>>};	
}

