package SomePackage;

/* Very basic class used for testing volume calculations
 * Entire class has 38 lines of code
 * All methods have are 3 lines of code
 */

public class ClassA {
	private int a;
	// this 
	private int b;
	// class
	// is
	private int c;
	/* interspersed */
	private int d;
	
	/* with */ private int e; /* some */
	
	/* Comments
	 * to make sure 
	 */
	private int getE() {
		return e;
	}
	private void setE(int e) {
		/* those comments do not influence */
		this.e = e;
	}
	private int getD() {
		return d;
	/* the line count
	 * 	
	 */}
	
	/* include some of the source in the comments to make sure we don't strip out everything that lies within
	 * the comment bloc
	 */
	
	/*
	private void setD(int d) {
		this.d = d;
	}
	private int getC() {
		return c;
	}
	private void setC(int c) {
		this.c = c;
	}
	*/
	
	private void setD(int d) {
		this.d = d;
	}
	private int getC() {
		return c;
	}
	private void setC(int c) {
		this.c = c;
	}
	private int getB() {
		return b;
	}
	private void setB(int b) {
		this.b = b;
	}
	private int getA() {
		return a;
	}
	private void setA(int a) {
		this.a = a;
	}	
}
