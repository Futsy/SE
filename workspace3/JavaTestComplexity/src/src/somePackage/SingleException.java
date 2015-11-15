package src.somePackage;

public class SingleException {

	public void m1()	// Call function that throws, possible second path in exception handler: Complexitt 2
	{
		System.out.println("Let's do something dangerous");
		
		try
		{
			ThisMightThrow();
			System.out.println("w00t, that worked");
		}
		catch(SomeException ex)
		{
			System.out.println("Crap we got an exception");
		}
		
		System.out.println("Phew, that's done");
	}
}
