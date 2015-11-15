package src.somePackage;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

public class Combinations2 {
	
	private List<String> someList = Arrays.asList("this", "is", "a", "list", "of", "strings");

	public void m1()	
	{
		System.out.println("Combinations");
		
		if(Foo())
		{
			if(bar())
			{
				DoSomething();
			}
			else 
			{
				for(int i = 0 ; i < 12 ; i++)
				{
					doSomethingElse();
				}
			}
		}
		else
		{
			int option = GetOption();
			switch(option)
			{
			case 0: Do0();
			case 1: Do1();
			case 5: Do5();
			default: DoDefault();
			}
		}
		
		System.out.printf("b = %s", val);
	}
}



/*
 * 							[] if(Foo()
 * 		---------------------------------	
 * 		| !Foo()						| Foo()
 * 		[] switch						|
 * 	-------------						[] if(Bar()
 * 	|	|	|	|				-----------------
 * 	[] 	[]	[]	[]				| !Bar()		| Bar()
 * 	|	|	|	|				|				|
 * 	|	|	|	|			-->[] for(..)		[] DoSomething
 * 	|	|	|	|			|	|				|
 * 	|	|	|	|			|	|				|
 * 	|	|	|	|			---[] doSom..		|
 * 	|	|	|	|				|				|
 * 	---------------------------------------------
 * 						|
 *						[]
 *
 *	Nodes: 11
 *	Edges: 16
 * 	CC == 16-11+2 = 7
 */