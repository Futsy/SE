package somePackage;

import java.io.PrintStream;
import java.io.IOException;
import java.io.File;
import java.util.Random;

// LOC entire class: 51
//LOC clone: 10 (the preceding { included)

public class ClassC {
	public void RandIntsToFile(String[] args)
	{	try
		{	PrintStream writer = new PrintStream( new File("randInts.txt"));
			Random r = new Random();
			final int LIMIT = 100;

			for(int i = 0; i < LIMIT; i++)
			{	writer.println( r.nextInt() );
			}
			writer.close();
		}
		catch(IOException e)
		{	System.out.println("An error occured while trying to write to the file");
		}
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
	
	public void printSomeCrap(String[] args)
	{	String s1 = "Computer Science";
		int x = 307;
		String s2 = s1 + " " + x;
		String s3 = s2.substring(10,17);
		String s4 = "is fun";
		String s5 = s2 + s4;
		
		System.out.println("s1: " + s1);
		System.out.println("s2: " + s2);
		System.out.println("s3: " + s3);
		System.out.println("s4: " + s4);
		System.out.println("s5: " + s5);
		
		//showing effect of precedence
		
		x = 3;
		int y = 5;
		String s6 = x + y + "total";
		String s7 = "total " + x + y;
		String s8 = " " + x + y + "total";
		System.out.println("s6: " + s6);
		System.out.println("s7: " + s7);
		System.out.println("s8: " + s8);
	}
}
