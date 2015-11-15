package somePackage;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

public class SingleForEach {

	public void m1()	// Single loop: Complexity 2
	{
		// Create a list of strings
		List<String> someList = Arrays.asList("this", "is", "a", "list", "of", "strings");
		
		/* Iterate over the list */
		for(Iterator<String> i = someList.iterator(); i.hasNext(); ) {
		    String item = i.next();
		    System.out.println(item);
		}
		
		System.out.println("Whoop whoop, Iterated a list");
	}
}
