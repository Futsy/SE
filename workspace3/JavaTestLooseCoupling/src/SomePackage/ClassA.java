package SomePackage;

/* Very basic class used for testing volume calculations
 * Entire class has 38 lines of code
 * All methods have are 3 lines of code
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
		i.IM1(5);
		s.length();
	}
	
	private void Bar()
	{
		i.IM2(3.14);
	}
	
	private void FooBar()
	{
		i.IM2(42.0);
		cb.getA();
	}
	
}