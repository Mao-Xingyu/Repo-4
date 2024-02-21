__kernel void desubstitute(__global char *originalVector, 
						 __global char *substitutedVector) {
	int gid = get_global_id(0);
	switch(originalVector[gid]){
		case 'G':	substitutedVector[gid] = 'a';
					break;
		case 'X':	substitutedVector[gid] = 'b';
					break;
		case 'S':	substitutedVector[gid] = 'c';
					break;
		case 'Q':	substitutedVector[gid] = 'd';
					break;
		case 'F':	substitutedVector[gid] = 'e';
					break;	
		case 'A':	substitutedVector[gid] = 'f';
					break;
		case 'R':	substitutedVector[gid] = 'g';
					break;
		case 'O':	substitutedVector[gid] = 'h';
					break;
		case 'W':	substitutedVector[gid] = 'i';
					break;
		case 'B':	substitutedVector[gid] = 'j';
					break;
		case 'L':	substitutedVector[gid] = 'k';
					break;
		case 'M':	substitutedVector[gid] = 'l';
					break;
		case 'T':	substitutedVector[gid] = 'm';
					break;
		case 'H':	substitutedVector[gid] = 'n';
					break;
		case 'C':	substitutedVector[gid] = 'o';
					break;
		case 'V':	substitutedVector[gid] = 'p';
					break;
		case 'P':	substitutedVector[gid] = 'q';
					break;
		case 'N':	substitutedVector[gid] = 'r';
					break;
		case 'Z':	substitutedVector[gid] = 's';
					break;
		case 'U':	substitutedVector[gid] = 't';
					break;
		case 'I':	substitutedVector[gid] = 'u';
					break;
		case 'E':	substitutedVector[gid] = 'v';
					break;
		case 'Y':	substitutedVector[gid] = 'w';
					break;
		case 'D':	substitutedVector[gid] = 'x';
					break;
		case 'K':	substitutedVector[gid] = 'y';
					break;
		case 'J':	substitutedVector[gid] = 'z';
					break;
		default:
					substitutedVector[gid] = originalVector[gid];
	}
}