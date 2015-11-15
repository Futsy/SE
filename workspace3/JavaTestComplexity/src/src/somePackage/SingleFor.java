package src.somePackage;

public class SingleFor {

	public void m1()	// Single for loop: Conplexity 2
	{
		System.out.println("Let's do some looping");
		int a = 3;
		int b = 5;
		
		for(int i = 0; i < 3 ; i++)
		{
			System.out.printf("Yeey, loop %d", i+1);
		}
		
		System.out.printf("FYI: %d + %d = %d", a,b,a+b);
	}
}
