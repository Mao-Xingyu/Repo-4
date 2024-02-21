#define CL_USE_DEPRECATED_OPENCL_2_0_APIS	// using OpenCL 1.2, some functions deprecated in OpenCL 2.0
#define __CL_ENABLE_EXCEPTIONS				// enable OpenCL exemptions

// C++ standard library and STL headers
#include <iostream>
#include <vector>
#include <fstream>

// OpenCL header, depending on OS
#ifdef __APPLE__
#include <OpenCL/cl.hpp>
#else
#include <CL/cl.hpp>
#endif

#include "common.h"
#include "bmpfuncs.h"

int main(void)
{
	cl::Platform platform;			// device's platform
	cl::Device device;				// device used
	cl::Context context;			// context for the device
	cl::Program program;			// OpenCL program object
	cl::Kernel kernel;				// a single kernel object
	cl::CommandQueue queue;			// commandqueue for a context and device

		// declare data and memory objects
	unsigned char* inputImage;
	unsigned char* outputImage;
	int imgWidth, imgHeight, imageSize;

	cl::ImageFormat imgFormat;
	cl::Image2D inputImgBuffer, outputImgBuffer;

	try {
		// select an OpenCL device
		if (!select_one_device(&platform, &device))
		{
			// if no device selected
			quit_program("Device not selected.");
		}

		// create a context from device
		context = cl::Context(device);

		// build the program 
		if (!build_program(&program, &context, "gaussianBlur.cl"))
		{
			// if OpenCL program build error
			quit_program("OpenCL program build error.");
		}

		// create a kernel
		kernel = cl::Kernel(program, "gaussianBlur");

		// create command queue
		queue = cl::CommandQueue(context, device);

		// read input image
		inputImage = read_BMP_RGB_to_RGBA("peppers.bmp", &imgWidth, &imgHeight);

		// allocate memory for output image
		imageSize = imgWidth * imgHeight * 4;
		outputImage = new unsigned char[imageSize];

		// image format
		imgFormat = cl::ImageFormat(CL_RGBA, CL_UNORM_INT8);

		// create image objects
		inputImgBuffer = cl::Image2D(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, imgFormat, imgWidth, imgHeight, 0, (void*)inputImage);
		outputImgBuffer = cl::Image2D(context, CL_MEM_WRITE_ONLY | CL_MEM_COPY_HOST_PTR, imgFormat, imgWidth, imgHeight, 0, (void*)outputImage);

		// set kernel arguments
		kernel.setArg(0, inputImgBuffer);
		kernel.setArg(1, outputImgBuffer);

		// enqueue kernel
		cl::NDRange offset(0, 0);
		cl::NDRange globalSize(imgWidth, imgHeight);

		queue.enqueueNDRangeKernel(kernel, offset, globalSize);

		std::cout << "Kernel naive Gaussian Blur enqueued." << std::endl;
		std::cout << "--------------------" << std::endl;

		// enqueue command to read image from device to host memory
		cl::size_t<3> origin, region;
		origin[0] = origin[1] = origin[2] = 0;
		region[0] = imgWidth;
		region[1] = imgHeight;
		region[2] = 1;

		queue.enqueueReadImage(outputImgBuffer, CL_TRUE, origin, region, 0, 0, outputImage);

		// output results to image file
		write_BMP_RGBA_to_RGB("naiveGaussianBlur.bmp", outputImage, imgWidth, imgHeight);

		std::cout << "Completed processing image with Gaussian Blur (Naive). Output image name:  naiveGaussianBlur.bmp" << std::endl;

		//Parallel Processing
		// build the program 
		if (!build_program(&program, &context, "parallelGaussianBlur.cl"))
		{
			// if OpenCL program build error
			quit_program("OpenCL program build error.");
		}
		//(first pass)
		kernel = cl::Kernel(program, "gaussianBlurHorizontalPass");

		//input buffer read only
		inputImgBuffer = cl::Image2D(context, CL_MEM_READ_ONLY | CL_MEM_COPY_HOST_PTR, imgFormat, imgWidth, imgHeight, 0, (void*)inputImage);
		//output buffer is set to read and writeable so it can be written to on the first pass, and read in again and written again on the 2nd pass.
		outputImgBuffer = cl::Image2D(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, imgFormat, imgWidth, imgHeight, 0, (void*)outputImage);

		// set kernel arguments 
		kernel.setArg(0, inputImgBuffer); //Read
		kernel.setArg(1, outputImgBuffer); //Write to

		queue.enqueueNDRangeKernel(kernel, offset, globalSize);

		std::cout << "Kernel gaussian blur (horizontal pass) enqueued." << std::endl;
		std::cout << "--------------------" << std::endl;

		std::cout << "Processed image (first pass) with Gaussian Blur." << std::endl;

		//(second pass)
		kernel = cl::Kernel(program, "gaussianBlurVerticalPass");

		// set kernel arguments
		kernel.setArg(0, outputImgBuffer);
		kernel.setArg(1, outputImgBuffer);

		queue.enqueueNDRangeKernel(kernel, offset, globalSize);

		std::cout << "Kernel gaussian blur (vertical pass) enqueued." << std::endl;
		std::cout << "--------------------" << std::endl;

		std::cout << "Processed image (2nd pass) with Gaussian Blur." << std::endl;
		queue.enqueueReadImage(outputImgBuffer, CL_TRUE, origin, region, 0, 0, outputImage);

		// output results to image file
		write_BMP_RGBA_to_RGB("parallelGaussianBlur.bmp", outputImage, imgWidth, imgHeight);

		std::cout << "Completed processing image with Gaussian Blur (Parallel-2 pass). Output image name:  parallelGaussianBlur.bmp" << std::endl;

		// deallocate memory
		free(inputImage);
		free(outputImage);
	}
	// catch any OpenCL function errors
	catch (cl::Error e) {
		// call function to handle errors
		handle_error(e);
	}

#ifdef _WIN32
	// wait for a keypress on Windows OS before exiting
	std::cout << "\npress a key to quit...";
	std::cin.ignore();
#endif

	return 0;
}
