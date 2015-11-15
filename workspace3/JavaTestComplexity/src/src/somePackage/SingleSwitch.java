package somePackage;

public class SingleSwitch {

	public void m1(int param)	// Switch with 5 options (including default): complexity 5
	{
		switch(param)
		{
		case 0: DoOptionZero(); break;
		case 1: DoOptionOne(); break;
		case 2: DoOptionTwo(); break;
		case 3: DoOptionThree(); break;
		default: DoDefault(); break;
		}
		
		System.out.println("Did me some nice swithcing");
	}
}
