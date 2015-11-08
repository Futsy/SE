package testCloneDetection;

public class A {

	private int a = 5;
	private int b = 6;
	private int c = 7;
	private int d = 8;
	private int e = 9;
	private int f = 10;
	private int g = 11;
	private int h = 12;
	
	public void func1()
	{
		a = b / c;
		b = 4 +5;
		c = a * b;
		d = nonExistingFuncCall(5);
		e = e;
		f = f * f;	
	}	
}
