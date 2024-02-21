__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | 
      CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST; 

// 1x7 / 7x1
__constant float blurFilter[7] = {0.00598, 0.060626, 0.241843, 0.383103, 0.241843, 0.060626, 0.00598};


__kernel void luminance(read_only image2d_t src_image,
					write_only image2d_t dst_image,
                    float luminance) {
   /* Get pixel coordinate */
   int2 coordinates = (int2)(get_global_id(0), get_global_id(1));

   /* Read pixel value */
   float4 pixel = read_imagef(src_image, sampler, coordinates);

   /* if it is above our threshold value darken it */
   if((pixel.x + pixel.y + pixel.z) / 3 <= luminance){
        pixel.xyz = 0;
   }

   /* Write new pixel value to output */
	write_imagef(dst_image, coordinates, pixel);
}

__kernel void horizontalBlur(read_only image2d_t src_image,
					write_only image2d_t dst_image) {
	
	/* Get work-item’s row and column position */
	int column = get_global_id(0); 
	int row = get_global_id(1);

	/* Accumulated pixel value */
	float4 sum = (float4)(0.0);

	/* Filter's current index */
	int filter_index =  0;

	int2 coordinates;
	float4 pixel;

	coordinates.y = row;
	for(int i = -1 ; i <= 5; i++){
		coordinates.x = column + i;
		pixel = read_imagef(src_image, sampler, coordinates);
		sum.xyz += pixel.xyz * blurFilter[filter_index++];
	}

	/* Write new pixel value to output */
	coordinates = (int2)(column, row); 
	write_imagef(dst_image, coordinates, sum);
}

__kernel void verticalBlur(read_only image2d_t src_image,
				write_only image2d_t dst_image) {
	/* Get work-item’s row and column position */
	int column = get_global_id(0); 
	int row = get_global_id(1);

	/* Accumulated pixel value */
	float4 sum = (float4)(0.0);

	/* Filter's current index */
	int filter_index =  0;

	int2 coordinates;
	float4 pixel;
	coordinates.x = column;

	for(int i = -1 ; i <= 5; i++){
		coordinates.y = row + i;
		pixel = read_imagef(src_image, sampler, coordinates);
		sum.xyz += pixel.xyz * blurFilter[filter_index++];
	}

	/* Write new pixel value to output */
	coordinates = (int2)(column, row); 
	write_imagef(dst_image, coordinates, sum);
}


__kernel void bloom(read_only image2d_t src_image,
						   read_only image2d_t src_image_two,
						   write_only image2d_t dst_image) {
	/* Get work-item’s row and column position */
	int column = get_global_id(0); 
	int row = get_global_id(1);

	/* Accumulated pixel value */
	float4 sum = (float4)(0.0);

	float4 pixel;
	int2 coordinates = (int2)(get_global_id(0), get_global_id(1));
   
   	/* read in the RGB value of each pixel in first image and add to the float4 sum pixel value */ 
   	pixel = read_imagef(src_image, sampler, coordinates);
	sum.x = pixel.x;
	sum.y = pixel.y;
	sum.z = pixel.z;
 
    /* read in the RGB value of each pixel in the 2nd image to float4 pixel and 
    combine them from the previous float4 pixel value in sum. */
	pixel = read_imagef(src_image_two, sampler, coordinates);
	
	pixel.x += sum.x;
	pixel.y += sum.y;
	pixel.z += sum.z;

	if((pixel.x + pixel.y + pixel.z) / 3 > 1.0){
		pixel.xyz = 1;
	}

	/* Write new pixel value to output */
	write_imagef(dst_image, coordinates, pixel);
}



