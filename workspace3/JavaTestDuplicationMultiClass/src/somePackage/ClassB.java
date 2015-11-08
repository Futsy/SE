package somePackage;

// LOC entire class: 39
//LOC clone: 10 (the preceding { included)

public class ClassB {

	int base;
	
	public ClassB(int base)
	{
		this.base = base;
	}
	
	public int Power(int pow)
	{
		int result = 1;
		
		while(pow > 0)
		{
			result = result * base;
			pow--;
		}
		
		return result;
	}
	
	public int substract(int rhs)
	{
		return base - rhs;
	}
	
	public int add(int rhs)
	{
		return base + rhs;
	}
	
	public int multiply(int rhs)
	{
		return base * rhs;
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
}
