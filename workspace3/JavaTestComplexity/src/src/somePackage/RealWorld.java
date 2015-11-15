package src.somePackage;

/*
 *  To really put our calculation to the test, we wanted to try on some real world code instead of the code we 
 *  could come up with ourselves. The 'realworld' java files contain stuff we picked off of github
 *  
 *  source: https://github.com/SquareSquash/java/blob/master/src/main/java/com/squareup/squash/SquashBacktrace.java
 */

class RealWorld
{

public static Map<String, Object> getIvars(Throwable error) {
    if (error == null) {
      return null;
    }
    Map<String, Object> ivars = new HashMap<String, Object>();
    final Field[] fields = error.getClass().getDeclaredFields();
    for (Field field : fields) {
      try {
        if (!Modifier.isStatic(field.getModifiers()) // Ignore static fields.
            && !field.getName().startsWith("CGLIB")) { // Ignore mockito stuff in tests.
          if (!field.isAccessible()) {
            field.setAccessible(true);
          }
          Object val = field.get(error);
          ivars.put(field.getName(), val);
        }
      } catch (IllegalAccessException e) {
        ivars.put(field.getName(), "Exception accessing field: " + e);
      }
    }
    return ivars;
  }
}

/*		[] if(error..
 * 	---------------------------------
 * 	|								|
 * 	|								[] map....Fiels()..
 *  |								|
 *  |								[] for(Field...
 *  |								|
 *  |								[] try
 *  |							   /|
 *  |							 /	|
 *  |						   /	[] Modifier.isStat...
 *  |			ivars.put..  []		| \
 *  |						 |		|   \
 *	|						 |		|	 [] field.getName...
 *	|						 |		|	/					
 *	| 						 |		| /
 *	|						 |		|
 *	|						 |		[] if(... ln 21
 *	|						 |		| \
 *	|						 |		|	\
 *	|						 |		|	[] if!field.is...
 *	|						 |		|	| \
 *	|						 |		|	|	\
 *	|						 |		|	|	[] field.setAcc..
 *	|						 |		|	|  / 
 *	|						 |		|	|/	
 *	|						 |		|	|	
 *	|						 |		|	[] Object val.....
 *	|						 |      |   |
 *	-------------------------------------
 *									|
 *									[]
 *	
 *	Nodes: 12
 *	Edges: 17
 *	CC: 17-12+2 = 7
 **/
 