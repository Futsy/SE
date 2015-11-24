package test;

public class MixedComments {
	private int a;
	// We intersperse this file
	private int b;
	private int c;
	/* with both single
	 * and multi line
	 * comments
	 */
	private int d;
	private int e;
	
	/* the interesting case is off course
	 * When we try to mix these
	 * // types of comments together 
	 */
	private int getE() {
		return e;
	}
	private void setE(int e) {
		this.e = e;
	}
	/* For instance to
	 * see if the end
	 * of ML comment is
	 * ignored here
	 // */
	private int getD() {
		return d;
	}
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
