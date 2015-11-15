package src.somePackage;

public class SingleOr {

	public void m1()	// Extra path due to execution of Bar() depending on result of Foo(): Complexity 2
	{
		System.out.println("Boolean logic");
		
		boolean b = Foo() || Bar();
		
		String val = boolToString(b);
		
		System.out.printf("b = %s", val);
	}
}
