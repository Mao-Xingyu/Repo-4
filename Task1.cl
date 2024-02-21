__kernel void Task1(__global int *arrayOne,
					 __global int *arrayTwo,
					 __global int *outputArray) {
   
   //create our int8 vectors.
   __local int8 v, v1, v2, results;

   //Load the array we passed in to the kernel into int8 vectors
   v = vload8 (0, arrayOne);
   v1 = vload8 (0, arrayTwo);      
   v2 = vload8 (1, arrayTwo);

   //Creating private memory vector results
   //use select function to choose element from v1 and v2 based on isgreater() into results
   if (any(v>15) == 1)
   {
        results.s0 = select(v2.s0, v1.s0, isgreater(v.s0, 15.0));
        results.s1 = select(v2.s1, v1.s1, isgreater(v.s1, 15.0));
        results.s2 = select(v2.s2, v1.s2, isgreater(v.s2, 15.0));
        results.s3 = select(v2.s3, v1.s3, isgreater(v.s3, 15.0));
        results.s4 = select(v2.s4, v1.s4, isgreater(v.s4, 15.0));
        results.s5 = select(v2.s5, v1.s5, isgreater(v.s5, 15.0));
        results.s6 = select(v2.s6, v1.s6, isgreater(v.s6, 15.0));
        results.s7 = select(v2.s7, v1.s7, isgreater(v.s7, 15.0));
   }
   else
   {
   //.lo suffix refers to the lower half of a given vector
   //.hi suffix refers to the upper half of a given vector
        results.lo = v1.lo;
        results.hi = v2.lo;
   }
   //store content of v, v1, v2, and results in outputArray using vstore
   vstore8 (v,0, outputArray);
   vstore8 (v1,1, outputArray);
   vstore8 (v2,2, outputArray);
   vstore8 (results,3, outputArray);
}
