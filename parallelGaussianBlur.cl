__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST; 

// 1x7 / 7x1
__constant float gaussianFilter[7] = {0.00598, 0.060626, 0.241843, 0.383103, 0.241843, 0.060626, 0.00598};

__kernel void gaussianBlurHorizontalPass(	read_only image2d_t src_image,
						write_only image2d_t dst_image) {

    /* Get work-item’s row and column position */
    int column = get_global_id(0); 
    int row = get_global_id(1);

    /* Accumulated pixel value */
    float4 sum = (float4)(0.0);

     /* Filter's current index */
    int filter_index =  0;

    int2 coordinates;
    coordinates.y = row;
    for(int i = -1; i <= 5; i++){
        coordinates.x = column + i;
		float4 pixel = read_imagef(src_image, sampler, coordinates);
		sum.xyz += pixel.xyz * gaussianFilter[filter_index++];
    }
   
    /* Write new pixel value to output */
    coordinates = (int2)(column, row); 
    write_imagef(dst_image, coordinates, sum);
}


__kernel void gaussianBlurVerticalPass(	read_only image2d_t src_image,
						write_only image2d_t dst_image) {

    /* Get work-item’s row and column position */
    int column = get_global_id(0); 
    int row = get_global_id(1);

    /* Accumulated pixel value */
    float4 sum = (float4)(0.0);

     /* Filter's current index */
    int filter_index =  0;

    int2 coordinates;
    coordinates.x = column;
    for(int i = -1; i <= 5; i++){
        coordinates.y = row + i;
		float4 pixel = read_imagef(src_image, sampler, coordinates);
		sum.xyz += pixel.xyz * gaussianFilter[filter_index++];
    }
   
    /* Write new pixel value to output */
    coordinates = (int2)(column, row); 
    write_imagef(dst_image, coordinates, sum);
}


