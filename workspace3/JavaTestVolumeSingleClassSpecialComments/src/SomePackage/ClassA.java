package SomePackage;

/* 
 * I have added this test case becasue we came across it when comparing two methods for determining LOC
 * The one that used the model's comment section to remove comments from the code turned out to give 
 * faulty results sometimes. In each of those files, there were multi line comments in what I call doxygen
 * style: /**
 * I'm not 100% what triggers this behavior, because it doesn't always happen with these type of comments
 * I have modelled this file after one of the files in which we encountered the bug. It is included here
 * so it can be easily reproduced
 */

/**
 * @author BGR
 */
public class ClassA {
	private int a;
	private int b;
	
	/**
	 * put some 'doxygen' like multi line comments in here
	 */	
	
	private int c;
	private int d;
	
	/**
	 * To see if the model really does not parse them properly.
	 */	
	private int e;
	
	
	private int getE() {
		return e;
	}
	private void setE(int e) {
		this.e = e;
	}
	private int getD() {
		return d;
	}
	private void setD(int d) {
		this.d = d;
	}    
    
    /**
     * Let's put another one right here, next to this little shrubbery
     */	
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
