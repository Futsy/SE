module MatchDetection::Text::Type3

// General imports
import IO;
import List;

// Project imports
import MatchDetection::Text::Type1;

// Aliases Type Clones
alias t3clone = list[t1clone];

list[t3clone] GetT3Clones(int threshold, list[t1clone] t1Clones)
{
	if (threshold < 2)
		return [];

	list[t3clone] t3Clones = [];
	
	for (t1Clone <- t1Clones) {
		// alias t1Pair  = tuple[loc file, int s, int end];
		// alias t1clone = tuple[t1Pair x, t1Pair y];
		t3clone t3Clone = [t1Clone];
		
		list[t1clone] t1 = [t1Clone];
		while (true)
		{
			t1 = FindNextType1(threshold, t1[0], t1Clones, false, true);
			if (size(t1) == 0)
				break;
			t3Clone += t1;
		}
		
		if (size(t3Clone) > 1)
			t3Clones += [t3Clone];
	}
	
	return t3Clones;
}

list[t1clone] FindNextType1(int threshold, t1clone clone, list[t1clone] t1Clones, bool incX, bool incY)
{
	for (bound <- [2..threshold + 1]) {
		for (t1Clone2 <- t1Clones) {
			if (clone.x.end + (incX ? bound : 1) == t1Clone2.x.s && (clone.y.end + (incY ? bound : 0) == t1Clone2.y.s) && clone.x.file == t1Clone2.x.file && clone.y.file == t1Clone2.y.file){
				return [t1Clone2];
			}
		}
	}
	
	return [];
}