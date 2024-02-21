__kernel void decipher(int key,
					 __global char *ptVector, 
					 __global char *ctVector) {

	int gid = get_global_id(0);
	if ((ctVector[gid] >= 'A') && (ctVector[gid] <= 'Z')) {
		ctVector[gid] = ctVector[gid] - key;

		if (ctVector[gid] > 'Z') {
			ctVector[gid] = ctVector[gid] - 'Z' + 'A' - 1;
		}
		else if (ctVector[gid] < 'A') {
			ctVector[gid] = ctVector[gid] - 'A' + 'Z' + 1;
		}

		ptVector[gid] = ctVector[gid];
	}
	else {
		ptVector[gid] = ctVector[gid];
	}
	
}