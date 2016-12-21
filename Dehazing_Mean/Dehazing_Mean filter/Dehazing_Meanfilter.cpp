

#include <stdlib.h>
#include "dehazing.h"

/*输入图像转换为伪彩色图显示
  Color : 颜色类型
  enum
  {
  COLORMAP_AUTUMN = 0,
  COLORMAP_BONE = 1,
  COLORMAP_JET = 2,
  COLORMAP_WINTER = 3,
  COLORMAP_RAINBOW = 4,
  COLORMAP_OCEAN = 5,
  COLORMAP_SUMMER = 6,
  COLORMAP_SPRING = 7,
  COLORMAP_COOL = 8,
  COLORMAP_HSV = 9,
  COLORMAP_PINK = 10,
  COLORMAP_HOT = 11
  }
*/
void DrawColorMap(IplImage *ImgInPut, int Color)
{ 

	cv::Mat mtx(ImgInPut);
	cv::Mat mty;
	cv::applyColorMap(mtx, mty, Color);
	IplImage ImgOuput_img = mty;
	cvShowImage("test", &ImgOuput_img);
//	cvSaveImage("C:\\Users\\振巍\\Desktop\\color-line截距直方图\\snow_gao_L.png", &ImgOuput_img);
}

/*Step 7: 数组形式*/
unsigned char * MakeLUT(double InvA)
{
	unsigned char * Table = (unsigned char  *)malloc(256 * 256 * sizeof(unsigned char));
	int Y , X, Index;
	double Value;
	for (Y = 0; Y < 256; Y++)
	{
		Index = Y << 8;
		for (X = 0; X < 256; X++)
		{
			Value = (Y - X) / (1 - X*InvA);
			if (Value > 255)
				Value = 255;
			else if (Value < 0)
				Value = 0;
			Table[Index++] = (uchar)Value;
		}
	}
	return Table;
}

unsigned char * MakeLightLUT(double A)
{
	unsigned char * Table = (unsigned char  *)malloc(256  * sizeof(unsigned char));
	int  X;
	double Value;
	
		for (X = 0; X < 256; X++)
		{
			Value = A*(255. - X) / (255. - A);
			Value = CLIP(Value);
			Table[X] = (uchar)Value;
		}
	
	return Table;
}

/*Step 2-1*/
double MinFilter(IplImage *img, IplImage* dst)
{

	IplImage *img_dark = cvCreateImage(cvSize(img->width, img->height), img->depth, 1);
	int Y, X, Min;
	int Sum = 0;
	int nStep = img->widthStep;
	int dStep = img_dark->widthStep;
	double Mean;
for (Y = 0 ; Y < img->height; Y++)
 {	
	for (X = 0; X < img->width; X++)
	 {
		Min = (uchar)img->imageData[Y*nStep + X * 3];
		if (Min >(uchar)(img->imageData[Y*nStep + X * 3 + 1])) Min = (uchar)(img->imageData[Y*nStep + X * 3 + 1]);
		if (Min >(uchar)(img->imageData[Y*nStep + X * 3 + 2])) Min = (uchar)(img->imageData[Y*nStep + X * 3 + 2]);
		img_dark->imageData[Y*dStep + X ] = (uchar)Min;         //    三通道的最小值
		Sum += Min;                                        //  累积以方便后面求平均值
	 }
  }

*dst = *img_dark;
Mean = ((double)Sum) / double(img->width*img->height * 255);
return Mean;

}
/*Step 2-2*/
/*dst1--img_light, dst2--img_dark*/
double MaxMinFilter(IplImage *img, IplImage* dst1, IplImage* dst2)
{

	IplImage *img_light = cvCreateImage(cvSize(img->width, img->height), img->depth, 1);
	IplImage *img_dark = cvCreateImage(cvSize(img->width, img->height), img->depth, 1);
	int Y, X, Max, Min;
	int Sum_Min = 0;
	int Sum_Max = 0;
	int cnt = 0;
	int nStep = img->widthStep;
	int dStep = img_light->widthStep;
	double Mean_Min;
	double Mean_Max;
#pragma omp parallel for
	for (Y = 0; Y < img->height; Y++)
	{
		for (X = 0; X < img->width; X++)
		{
			Max = (uchar)img->imageData[Y*nStep + X * 3];
			Min = (uchar)img->imageData[Y*nStep + X * 3];
			if (Max <(uchar)(img->imageData[Y*nStep + X * 3 + 1])) Max = (uchar)(img->imageData[Y*nStep + X * 3 + 1]);
			if (Max <(uchar)(img->imageData[Y*nStep + X * 3 + 2])) Max = (uchar)(img->imageData[Y*nStep + X * 3 + 2]);
			if (Min >(uchar)(img->imageData[Y*nStep + X * 3 + 1])) Min = (uchar)(img->imageData[Y*nStep + X * 3 + 1]);
			if (Min >(uchar)(img->imageData[Y*nStep + X * 3 + 2])) Min = (uchar)(img->imageData[Y*nStep + X * 3 + 2]);
			img_light->imageData[Y*dStep + X] = (uchar)Max;         //    三通道的最大值
			img_dark->imageData[Y*dStep + X] = (uchar)Min;          //    三通道的最小值
			
				Sum_Min += Min;                                        //  累积以方便后面求平均值
				cnt++;
			
			
//			Sum_Max += Max;
		}
	}

	*dst1 = *img_light;
	*dst2 = *img_dark;
	Mean_Min = ((double)Sum_Min) / double(cnt * 255);
//	Mean_Max = ((double)Sum_Max) / double(img->width*img->height * 255);
//	cout << "Mean_Max = " << Mean_Max << endl;
	return Mean_Min;

}

/*Step 5-1: 利用均值元素求取L*/

void Cal_L(IplImage *M, IplImage * M_ave, IplImage *L, double rou, double Mean)
{
	int nStep = M->widthStep;
	int n_Y = M->height;
	int n_X = M->width;

	uchar * ptr = (uchar *)M_ave->imageData;
	uchar * ptr_M = (uchar *)M->imageData;
//	uchar * ptr_L = (uchar *)L->imageData;
	 for (int Y = 0; Y < n_Y; Y++)
		{
			for (int X = 0; X < n_X; X++)
			{
				L->imageData[Y*nStep + X] = uchar(CLIP(0.9*min(uchar(min(rou*Mean, 0.9)*float(ptr[Y*nStep + X])), ptr_M[Y*nStep + X])));
//				L->imageData[Y*nStep + X] = uchar(0.5f*(float)ptr[Y*nStep + X]);
			}
		
		}
//	 L->imageData = (uchar )ptr_L;

}
/*Step 5-2: 利用最大最小值均值元素求取L*/

void Cal_L_MaxMin(IplImage *M, IplImage * m, IplImage *L, double rou, double Mean, double A)
{
	int nStep = M->widthStep;
	int n_Y = M->height;
	int n_X = M->width;
	int Min_num = 0;
	int Max_num = 0;
	double lamda = 0.;
	unsigned char * Table = (unsigned char  *)malloc( 256 * sizeof(unsigned char));
	Table = MakeLightLUT(A);
	double pro = Mean*1.6;
	uchar * ptr_Max = (uchar *)M->imageData;
	uchar * ptr_Min = (uchar *)m->imageData;
#pragma omp parallel for
	for (int Y = 0; Y < n_Y; Y++)
	{
		for (int X = 0; X < n_X; X++)
		{
			/*使用普通浮点运算*/
//			L->imageData[Y*nStep + X] = uchar(0.85*float(min(ptr_Min[Y*nStep + X] , uchar(A*(float(255 - ptr_Max[Y*nStep + X]))/(255. - A)))));
			/*使用查表*/
			L->imageData[Y*nStep + X] = uchar(CLIP_Fi(pro)*float(min(ptr_Min[Y*nStep + X], Table[ptr_Max[Y*nStep + X]])));
			/*使用查表,并增加计数*/
	/*		if (ptr_Min[Y*nStep + X] < Table[ptr_Max[Y*nStep + X]])
			{ 
				L->imageData[Y*nStep + X] = uchar(CLIP_Fi(pro)*float(ptr_Min[Y*nStep + X]));
			     Min_num++;
			}
			else
			{
				L->imageData[Y*nStep + X] = uchar(CLIP_Fi(pro)*float(Table[ptr_Max[Y*nStep + X]]));
				Max_num++;
			}
			*/
//			L->imageData[Y*nStep + X] = uchar(0.5f*(float)ptr_Min[Y*nStep + X] + 0.5f*(A*(float(255 - ptr_Max[Y*nStep + X])) / (255. - A)));
			//				L->imageData[Y*nStep + X] = uchar(0.5f*(float)ptr[Y*nStep + X]);
		}

	}
//	lamda = (double)Min_num / (double)Max_num;
	cout << "Pro" << CLIP_Fi(pro) << endl;
}


void Cal_L_MaxMin_val(IplImage* H, IplImage *M, IplImage * m, IplImage *L, double A)
{
	int nStep = M->widthStep;
	int n_Y = M->height;
	int n_X = M->width;
	int Min_num = 0;
	int Max_num = 0;
	double fi = 0.;
	uchar mean_Y;

	unsigned char * Table = (unsigned char  *)malloc(256 * sizeof(unsigned char));
	Table = MakeLightLUT(A);

	unsigned char * Table_Y = (unsigned char  *)malloc(n_Y*n_X * sizeof(unsigned char));
	mean_Y = IplImageToInt(H, Table_Y);

// 	double * Table_Ratio = (double *)malloc(n_Y*n_X* sizeof(double));
//	Table_Ratio = MakeRatioLUT(mean_Y, Table_Y, n_Y, n_X);

//	double pro = Mean*1.667;
	uchar * ptr_Max = (uchar *)M->imageData;
	uchar * ptr_Min = (uchar *)m->imageData;
	for (int Y = 0; Y < n_Y; Y++)
	{
		for (int X = 0; X < n_X; X++)
		{   
			/*根据像素灰度调整L的系数大小*/
			fi = CLIP_Z(1.0 - double(abs(Table_Y[Y*nStep + X]-mean_Y)*2)/255);
			/*使用查表*/
			L->imageData[Y*nStep + X] = uchar(fi*float(min(ptr_Min[Y*nStep + X], Table[ptr_Max[Y*nStep + X]])));
	
		}

	}
	
//	cout << "Mean_Y=" << mean_Y << endl;
}

/*Step 6： 利用M_ave和输入图像求取A*/
double Cal_A(IplImage* M_ave, IplImage * H)
{
	
	int Y, X, Max_H;
	double Max_ave;
	double A;
	long Sum = 0;
	int nStep = H->widthStep;	
#pragma omp parallel for
	for (Y = 0; Y < H->height; Y++)
	{
		for (X = 0; X < H->width; X++)
		{
//			Max_H = (uchar)H->imageData[Y*nStep + X * 3];
//			if (Max_H >(uchar)(H->imageData[Y*nStep + X * 3 + 1])) Max_H = (uchar)(H->imageData[Y*nStep + X * 3 + 1]);
//			if (Max_H >(uchar)(H->imageData[Y*nStep + X * 3 + 2])) Max_H = (uchar)(H->imageData[Y*nStep + X * 3 + 2]);
			Sum+= (19595 * (uchar)H->imageData[Y*nStep + X * 3 + 2]
				+ 38469 * (uchar)H->imageData[Y*nStep + X * 3 + 1]
				+ 7471 * (uchar)H->imageData[Y*nStep + X * 3]) >> 16;
		}
//		if (Max_H == 255) break;
	}
	
//	cvMinMaxLoc(M_ave, NULL, &Max_ave, NULL);
	A = 1.6*((double)Sum/(double(H->height*H->width)))-35.7f;
	cout << "A=" << A << endl;
	return A;
}


/*Step 7: 求取输出图像
  F=(H-L)/(1-L/A) 三通道的值*/
void OutPut_Color(IplImage *H, IplImage *L, IplImage * Output, double A)
{
	int HStep = H->widthStep;
	int LStep = L->widthStep;
	int n_Y = H->height;
	int n_X = H->width;
	unsigned char * Table = (unsigned char  *)malloc(256 * 256 * sizeof(unsigned char));
	Table = MakeLUT(1.0 / A);
//	cvShowImage("Raw", H);
//	cvShowImage("L", L);
#pragma omp parallel for
	for (int Y = 0; Y < n_Y; Y++)
	{
		for (int X = 0; X < n_X; X++)
		{
//			Output->imageData[Y*HStep + X * 3] = (uchar)CLIP((float)(H->imageData[Y*HStep + X*3] - L->imageData[Y*LStep + X])/ CLIP_Z((1.0f- (double)(L->imageData[Y*LStep + X])/A)));
//			Output->imageData[Y*HStep + X * 3+1] = (uchar)CLIP((float)(H->imageData[Y*HStep + X * 3+1] - L->imageData[Y*LStep + X]) / CLIP_Z((1.0f - (double)(L->imageData[Y*LStep + X]) / A)));
//			Output->imageData[Y*HStep + X * 3+2] = (uchar)CLIP((float)(H->imageData[Y*HStep + X * 3+2] - L->imageData[Y*LStep + X]) / CLIP_Z((1.0f - (double)(L->imageData[Y*LStep + X]) / A)));
			Output->imageData[Y*HStep + X * 3] = CLIP((uchar)Table[(uchar(H->imageData[Y*HStep + X * 3]) << 8) + L->imageData[Y*LStep + X]]);
			Output->imageData[Y*HStep + X * 3 + 1] = CLIP((uchar)Table[(uchar(H->imageData[Y*HStep + X * 3 + 1]) << 8) + L->imageData[Y*LStep + X]]);
			Output->imageData[Y*HStep + X * 3 + 2] = CLIP((uchar)Table[(uchar(H->imageData[Y*HStep + X * 3 + 2]) << 8) + L->imageData[Y*LStep + X]]);
		}

	}

}
void cvShowManyImages(char * title, int nArgs, ...)
{

	// img - Used for getting the arguments
	IplImage *img;

	// DispImage - the image in which input images are to be copied
	IplImage *DispImage;

	int size;
	int i;
	int m, n;
	int x, y;

	// w - Maximum number of images in a row
	// h - Maximum number of images in a column
	int w, h;

	// scale - How much we have to resize the image
	float scale;
	int max;

	// If the number of arguments is lesser than 0 or greater than 12
	// return without displaying
	if (nArgs <= 0) {
		printf("Number of arguments too small....n");
		return;
	}

	else if (nArgs > 12) {
		printf("Number of arguments too large....n");
		return;
	}
	// Determine the size of the image,
	// and the number of rows/cols
	// from number of arguments
	else if (nArgs == 1) {
		w = h = 1;
		size = 300;
	}
	else if (nArgs == 2) {
		w = 2; h = 1;
		size = 300;
	}
	else if (nArgs == 3 || nArgs == 4) {
		w = 2; h = 2;
		size = 300;
	}
	else if (nArgs == 5 || nArgs == 6) {
		w = 3; h = 2;
		size = 200;
	}
	else if (nArgs == 7 || nArgs == 8) {
		w = 4; h = 2;
		size = 200;
	}
	else {
		w = 4; h = 3;
		size = 150;
	}

	// Create a new 3 channel image
	DispImage = cvCreateImage(cvSize(75 + size*w, size*h - 50), 8, 3);

	// Used to get the arguments passed
	va_list args;
	va_start(args, nArgs);

	// Loop for nArgs number of arguments
	for (i = 0, m = 20, n = 20; i < nArgs; i++, m += (20 + size)) {

		// Get the Pointer to the IplImage
		img = va_arg(args, IplImage*);

		// Check whether it is NULL or not
		// If it is NULL, release the image, and return
		if (img == 0) {
			printf("Invalid arguments");
			cvReleaseImage(&DispImage);
			return;
		}

		// Find the width and height of the image
		x = img->width;
		y = img->height;

		// Find whether height or width is greater in order to resize the image
		max = (x > y) ? x : y;

		// Find the scaling factor to resize the image
		scale = (float)((float)max / size);

		// Used to Align the images
		if (i % w == 0 && m != 20) {
			m = 20;
			n += 20 + size;
		}

		// Set the image ROI to display the current image
		cvSetImageROI(DispImage, cvRect(m, n, (int)(x / scale), (int)(y / scale)));

		// Resize the input image and copy the it to the Single Big Image
		cvResize(img, DispImage);

		// Reset the ROI in order to display the next image
		cvResetImageROI(DispImage);
	}

	// Create a new window, and show the Single Big Image
	//cvNamedWindow( title, 1 );
	cvShowImage(title, DispImage);

	//cvDestroyWindow(title);

	// End the number of arguments
	va_end(args);

	// Release the Image Memory
	cvReleaseImage(&DispImage);
}

/*将RGB彩色图像矩阵iplimage转换为YUV空间，Y的一维数组里*/
/*
Function: IplImageToInt
Description: Convert the opencv type IplImage to integer

Parameters:
imInput - input IplImage
Return:
m_pnYImg - output integer array
*/
uchar IplImageToInt(IplImage* imInput, unsigned char *m_pnYImg)
{
	int nY, nX;
	int nStep;
	int m_nHei = imInput->height;
	int m_nWid = imInput->width;
	nStep = imInput->widthStep;
	int sum = 0;
	uchar mean_Y;
//	unsigned int * Table = (unsigned int  *)malloc(m_nHei *m_nWid * sizeof(unsigned int));
	for (nY = 0; nY<m_nHei; nY++)
	{
		for (nX = 0; nX<m_nWid; nX++)
		{
			
			m_pnYImg[nY*m_nWid + nX] =
				(19595 * (uchar)imInput->imageData[nY*nStep + nX * 3 + 2]
					+ 38469 * (uchar)imInput->imageData[nY*nStep + nX * 3 + 1]
					+ 7471 * (uchar)imInput->imageData[nY*nStep + nX * 3]) >> 16;
			sum += m_pnYImg[nY*m_nWid + nX];
		}
	}
//	m_pnYImg = Table;
	mean_Y = (sum) / (m_nHei*m_nWid);
	return mean_Y;
}

/*构造L系数表
input:
output:

*/
double * MakeRatioLUT(uchar mean_Y, unsigned char *m_pnYImg, int m_nHei, int m_nWid)
{
	double  * Table_Ratio = (double   *)malloc(m_nHei* m_nWid* sizeof(double));
	int  X;
	double Value;
#pragma omp parallel for
	for (X = 0; X < m_nHei* m_nWid; X++)
	{
		Value = double(abs(m_pnYImg[X]-mean_Y)*2)/255.;
		Table_Ratio[X] = CLIP_Z(Value);
		 
	}

	return Table_Ratio;
}


IplImage * change4channelTo3InIplImage(IplImage * src) {
	if (src->nChannels != 4)
	{
		return NULL;
	}

	IplImage * destImg = cvCreateImage(cvGetSize(src), IPL_DEPTH_8U, 3);
	for (int row = 0; row < src->height; row++) {
		for (int col = 0; col < src->width; col++) {
			CvScalar s = cvGet2D(src, row, col);
			cvSet2D(destImg, row, col, s);
		}
	}
}
	