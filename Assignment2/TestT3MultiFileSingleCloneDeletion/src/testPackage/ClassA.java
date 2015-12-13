package testPackage;

import java.util.ArrayList;
import java.util.List;

public class ClassA {

	public void Foo()
	{
		String line;
		List<Integer> myList = new ArrayList<Integer>();
		while(ReadStuffFromFile(line))
		{
			System.out.println("Read some stuff from a file: " + line);
			myList.add(Integer.parseInt(line));
		}
		
		for(int i=0 ; i<myList.size() ; i++)
		{
			System.out.println("I have this integer");
			System.out.println("And its value is" + myList.get(i).toString());
		}
		
		for(int i=0 ; i<myList.size() ; i++)
		{
			Integer temp = myList.get(i);
			temp = temp +3 * temp;
			temp = temp * temp;
			myList.set(i, temp);
		}
	}
}
