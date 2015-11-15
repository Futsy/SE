package somePackage;

public class SingleIfElse {

	public void m1()	// the else does not change the number of possible paths: complexity 2
	{
		int a = 3;
		int b = 5;
		int c;
		if(a < b)
		{
			c = a * c + b /c;
		}
		else
		{
			c = 0;
		}
		System.out.printf("Some data: %d", c);
	}
}
