module unittests::complexity

import complexity;
import List;
import lang::java::jdt::m3::AST;
import IO;

test bool testSingleBranch()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleBranch.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <1,6>;
}

test bool testSingleIf()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleIf.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,10>;
}

test bool testSingleIfElse()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleIfElse.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,14>;
}

test bool testSingleFor()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleFor.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,10>;
}

test bool testSingleForEach()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleForEach.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,8>;
}

test bool testSingleSwitch()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleSwitch.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <5,11>;
}

test bool testSingleTernary()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleTernary.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,6>;
}

test bool testSingleException()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleException.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,13>;
}

test bool testSingleOr()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleOr.java|, false);
	cc = CalculateComplexity({ast});
	println(cc);
	return size(cc) == 1 && cc[0] == <2,6>;
}

test bool testSingleAnd()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/SingleAnd.java|, false);
	cc = CalculateComplexity({ast});
	return size(cc) == 1 && cc[0] == <2,6>;
}

test bool testCombinations1()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/Combinations1.java|, false);
	cc = CalculateComplexity({ast});
	println(cc);
	return size(cc) == 1 && cc[0] == <5,22>;
}

test bool testCombinations2()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/Combinations2.java|, false);
	cc = CalculateComplexity({ast});
	println(cc);
	return size(cc) == 1 && cc[0] == <7,29>;
}

test bool testRealWorld()
{
	ast = createAstFromFile(|file:///Users/Bouke/Documents/SE/workspace3/JavaTestComplexity/src/src/somePackage/RealWorld.java|, false);
	cc = CalculateComplexity({ast});
	println(cc);
	return size(cc) == 1 && cc[0] == <7,22>;
}