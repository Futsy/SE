module playing::Trees

import IO;

data T = tee(T, T, T) | i(int i);

public T t = tee(tee(i(1),i(2), i(3)),tee(i(4),i(5), i(6)),tee(i(7),i(8), i(9)));

public void fun()
{
	top-down visit(t)
	{
		case tee(_,_,_) : println("node");
		case i(x) : println("Leaf <x>");
	}
}