__kernel void substitute(__global char *originalVector, 
						 __global char *substitutedVector) {
	int gid = get_global_id(0);
	
	switch(originalVector[gid]){
		case 'a':	
		case 'A':	substitutedVector[gid] = 'G';
					break;
		case 'b':
		case 'B':	substitutedVector[gid] = 'X';
					break;
		case 'c':	
		case 'C':	substitutedVector[gid] = 'S';
					break;
		case 'd':	
		case 'D':	substitutedVector[gid] = 'Q';
					break;
		case 'e':	
		case 'E':	substitutedVector[gid] = 'F';
					break;
		case 'f':	
		case 'F':	substitutedVector[gid] = 'A';
					break;
		case 'g':	
		case 'G':	substitutedVector[gid] = 'R';
					break;
		case 'h':	
		case 'H':	substitutedVector[gid] = 'O';
					break;
		case 'i':	
		case 'I':	substitutedVector[gid] = 'W';
					break;
		case 'j':	
		case 'J':	substitutedVector[gid] = 'B';
					break;
		case 'k':
		case 'K':	substitutedVector[gid] = 'L';
					break;
		case 'l':
		case 'L':	substitutedVector[gid] = 'M';
					break;
		case 'm':
		case 'M':	substitutedVector[gid] = 'T';
					break;
		case 'n':
		case 'N':	substitutedVector[gid] = 'H';
					break;
		case 'o':
		case 'O':	substitutedVector[gid] = 'C';
					break;
		case 'p':
		case 'P':	substitutedVector[gid] = 'V';
					break;
		case 'q':
		case 'Q':	substitutedVector[gid] = 'P';
					break;
		case 'r':
		case 'R':	substitutedVector[gid] = 'N';
					break;
		case 's':
		case 'S':	substitutedVector[gid] = 'Z';
					break;
		case 't':
		case 'T':	substitutedVector[gid] = 'U';
					break;
		case 'u':
		case 'U':	substitutedVector[gid] = 'I';
					break;
		case 'v':
		case 'V':	substitutedVector[gid] = 'E';
					break;
		case 'w':
		case 'W':	substitutedVector[gid] = 'Y';
					break;
		case 'x':
		case 'X':	substitutedVector[gid] = 'D';
					break;
		case 'y':
		case 'Y':	substitutedVector[gid] = 'K';
					break;
		case 'z':
		case 'Z':	substitutedVector[gid] = 'J';
					break;
		default:
					substitutedVector[gid] = originalVector[gid];
	}
}
