package test;

public class MultiLineComments {
	private int a;
	/* intersperse */
	private int b;
	private int c;
	/* Code
	 * with 
	 * some
	 */
	private int d;
	private int e;
	
	private int getE() {
		/** multi 
		 * line
		 * comments 
		 */
		return e;
	}
	private void setE(int e) {
		this.e = e;
	}
	
	/** Include some code clones
	 * To make sure that doesn't mess things
	 * up
	 */
	private int getD() {
		return d;
	}
	/*
	private void setD(int d) {
		this.d = d;
	}
	*/
	private void setD(int d) {
		this.d = d;
	}
	private int getC() {
		return c;
	}
	/**
	private int getC() {
		return c;
	}
	 * @param c
	 */
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
