package SomePackage;

/* Very basic class used for testing coupling
 * We have 5 method invocations
 * 4 are into classes local to the project
 * Of those 4, 4 are to a concrete class
 */

interface SomeInterface
{
	public void IM1(int a);
	public String IM2(double b);
}

public class ClassA {
	
	private SomeInterface i;
	private String s;
	private ClassB cb;
	
	public ClassA(SomeInterface i)
	{
		this.i = i;
		this.s = "SomeString";
	}
	
	public void Foo()
	{
		cb.getE();
		s.length();
	}
	
	private void Bar()
	{
		cb.getD();
	}
	
	private void FooBar()
	{
		cb.setC(42);
		cb.getA();
	}
	
}
