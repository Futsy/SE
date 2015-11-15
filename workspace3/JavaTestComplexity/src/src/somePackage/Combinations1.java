package src.somePackage;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

public class Combinations1 {
	
	private List<String> someList = Arrays.asList("this", "is", "a", "list", "of", "strings");

	public void m1()	
	{
		System.out.println("Combinations");
		
		if(Foo() || Bar())
		{
			for(Iterator<String> i = someList.iterator(); i.hasNext(); ) {
			    String item = i.next();
			    System.out.println(item);
			}
		}
		else
		{
			try
			{
				SomeMethod();
			}
			catch(SomeException ex)
			{
				System.out.println("Well that sucked...");
			}
		}
		
		System.out.printf("b = %s", val);
	}
}

/*							[] println and Foo()
 * 							| \
 * 							|   \
 * 							|	 [] Bar()
 * 							|	 /
 * 							|  /
 * 							|/
 * 							[] if Foo() & Bar()
 * 							|
 * 			-------------------------------------
 * 			|									|
 * 			[] someM..							[]<--
 * 		   / |									|	|	for loop
 * 		 /	 |									[]---
 *  Ex []    |									|
 *      \	 |									|
 *        \  |									|
 *          \|									|
 *           |									|
 * 			 ------------------------------------
 * 							|
 * 							[]
 * 
 * 	Nodes: 8
 *  Edges: 11
 *  Complexity = 11-8+2 = 5
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
