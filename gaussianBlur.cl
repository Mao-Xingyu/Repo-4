__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST; 

// 7x7 Gaussian Blur filter
__constant float gaussianFilter[49] = {0.000036, 0.000363, 0.001446, 0.002291, 0.001446, 0.000363, 0.000036,
										0.000363, 0.003676, 0.014662, 0.023226, 0.014662, 0.003676, 0.000363,
										0.001446, 0.014662, 0.058488, 0.092651, 0.058488, 0.014662, 0.001446,
										0.002291, 0.023226, 0.092651, 0.146768, 0.092651, 0.023226, 0.002291,
										0.001446, 0.014662, 0.058488, 0.092651, 0.058488, 0.014662, 0.001446,
										0.000363, 0.003676, 0.014662, 0.023226, 0.014662, 0.003676, 0.000363,
										0.000036, 0.000363, 0.001446, 0.002291, 0.001446, 0.000363, 0.000036};


__kernel void gaussianBlur(	read_only image2d_t src_image,
						write_only image2d_t dst_image) {

    /* Get work-item’s row and column position */
    int column = get_global_id(0); 
    int row = get_global_id(1);

    /* Accumulated pixel value */
    float4 sum = (float4)(0.0);

     /* Filter's current index */
   int filter_index =  0;

    int2 coordinates;

    //apply gaussianblur filter to each pixel bbased on coordinates(x and y)
    for(int i = -1; i <= 5; i++){
        coordinates.y = row + i;
        for (int j = -1; j <= 5; j++){
            coordinates.x = column + j;
            /* Read value pixel from the image */ 		
			float4 pixel = read_imagef(src_image, sampler, coordinates);
			/* Acculumate weighted sum */ 		
			sum.xyz += pixel.xyz * gaussianFilter[filter_index++];

        }
    }
   
    /* Write new pixel value to output */
    coordinates = (int2)(column, row); 
    write_imagef(dst_image, coordinates, sum);
}
