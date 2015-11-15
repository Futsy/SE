package somePackage;

public class SingleTernary {

	public void m1()	// Single ternary: complexity 2
	{
		int a = 3;
		int b = 5;
		int c = a < b ? a * c + b /c :  0;
		
		System.out.printf("Some data: %d", c);
	}
}
