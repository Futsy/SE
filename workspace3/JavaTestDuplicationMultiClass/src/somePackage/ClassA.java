package somePackage;

// LOC entire class: 25
// LOC clone: 10 (the preceding { included)

public class ClassA {

	int i;
	String s;
	double d;
	
	public ClassA()
	{
		i = 5;
		s = "this is some string";
		d = 0.123;
	}
	
	public void duplicatedFunction(double base, int pow)
	{
		double result = 1.0;
		
		for(int i = 0 ; i < pow ; i++)
		{
			result *= base;
		}
		
		System.out.printf("result: %f", result);
	}
	
	public int someOtherFunction()
	{
		return (int)(d * i);
	}
}
