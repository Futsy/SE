package SomePackage;

/* class with 5 lines of duplication. This should not be flagged 
 * as a duplicate since the minumum is 6 lines
 */

public class ClassA {
	int a;
	int b;
	int c;
	int d;
	int e;
	
	public void Foo()
	{
		int a;
		int b;
		int c;
		int d;
		int e;
	}
}
