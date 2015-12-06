package test;

public class SingleLineComments {
	private int a;
	// Intersperse
	private int b;
	// this
	// code
	private int c;
	private int d;
	// with some
	private int e;
	
	private int getE() { //singe line
		return e; 
		//comments
	}
	
	// Include some of the code fragments to make sure that that doesn't mess things up:
	private void setE(int e) {
		this.e = e;
	}
	// private int getC() {
	// return c;
	// }
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
