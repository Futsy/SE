module pointersCodeAnalyses

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import IO;
import List;

// Create the M3 model

public M3 model = createM3FromEclipseProject(|project://smallsql0.21_src|);
//public M3 model = createM3FromEclipseProject(|project://hsqldb-2.3.1|);

public rel[loc from ,loc to] containment =  model@containment;

public list[loc] files = dup([files | files <- containment.from, files.scheme == "java+compilationUnit" ]);
