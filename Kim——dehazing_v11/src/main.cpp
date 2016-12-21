/*
	The main function is an example of video dehazing 
	The core algorithm is in "dehazing.cpp," "guidedfilter.cpp," and "transmission.cpp". 
	You may modify the code to improve the results.

	The detailed description of the algorithm is presented
	in "http://mcl.korea.ac.kr/projects/dehazing". See also 
	J.-H. Kim, W.-D. Jang, Y. Park, D.-H. Lee, J.-Y. Sim, C.-S. Kim, "Temporally
	coherent real-time video dehazing," in Proc. IEEE ICIP, 2012.

	Last updated: 2013-02-14
	Author: Jin-Hwan, Kim.
 */

#include "dehazing.h"
#include <time.h>
#include <conio.h>
CvCapture* capture = NULL;
void ON_Change(int n)
{
	cvSetCaptureProperty(capture, CV_CAP_PROP_POS_FRAMES, n);     //设置视频走到pos位置  
}

void cvShowManyImages(char* title, int nArgs, ...)
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
	DispImage = cvCreateImage(cvSize( 75+size*w,  size*h-50), 8, 3);

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

int main(int argc, char** argv)
{
	/*处理视频
	dehazing dehazingImg(nWid, nHei, 16, false, false, 5.0f, 1.0f, 40);类声明
	  参数赋值
	dehazingImg.HazeRemoval(imInput, imOutput, nFrame);
	  运用前后帧去雾
	FastGuidedFilter();
	  快速引导滤波
	*/

	

	int pos = 0;  //视频位置  
	char pause_flag = 1;
	IplImage *imInput;

	//视频声明
	//cvNamedWindow("In", 0);  //新建一个窗口
	cvNamedWindow("In", 0);
	cvResizeWindow("In", 1280, 640);
	//cvNamedWindow("Out", 0);  //新建一个窗口
	capture = cvCreateFileCapture("F:\\video_seq\\cross.avi");//创建一个视频
	int nWid = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
	int nHei = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);

	dehazing dehazingImg(nWid, nHei, 8, false, false, 5.0f, 1.0f, 60);
	/*
	Parameters:
	nW - width of input image
	nH - height of input image
	nTBLockSize - block size for transmission estimation
	bPrevFlag - boolean for temporal cohenrence of video dehazing
	bPosFlag - boolean for postprocessing
	fL1 - information loss cost parameter (regulating)
	fL2 - temporal coherence paramter
	nGBlock - guided filter block size
	*/
	
	IplImage *imOutput = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
	
	int frames = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_COUNT);        //返回视频帧的总数
	int nFrame = 0;
	CvVideoWriter *writer = cvCreateVideoWriter(
		"F:\\video_seq\\dtneu_nebel_kim.avi",
	//	CV_FOURCC('X', 'V', 'I', 'D'),
		-1,
		25,
		cvSize(nWid, nHei),
		1
		);
	cvCreateTrackbar("Trackbars", "In", &pos, frames, ON_Change);//创建滚动条
	CvFont font;
	char str[10];
	cvInitFont(&font,CV_FONT_HERSHEY_SIMPLEX, 1.0f, 1.0f, 0, 5, 8);// CV_FONT_HERSHEY_TRIPLEX
	double sum_t = 0.0;
	while (nFrame < frames)
	{
	     	double t = (double)cvGetTickCount();
		    imInput = cvQueryFrame(capture);  //获取下一帧图像
		    dehazingImg.HazeRemoval(imInput, imOutput, nFrame);
		    nFrame++;
			t = (double)cvGetTickCount() - t;
			sum_t += t;
			printf("run time per frame = %gms\n", t / 1000);
			printf("average run time per frame = %gms\n", sum_t / (1000 * nFrame ));
			//save video
//			if(imOutput)
//			cvWriteFrame(writer, imOutput);
			_itoa(pos, str, 10);
			pos++;              //播放一帧位置加1
			
		//	cvPutText(imInput, str, cvPoint(20, 80), &font, CV_RGB(0, 0, 0));
			cvShowManyImages("In", 2, imInput, imOutput);
			/*if (pos == 30)
			{
				cvSaveImage("F:\\自写文件\\论文插图第三波\\hazeroad_Kim_30.jpg", imOutput);
			}
			if (pos == 50)
			{
				cvSaveImage("F:\\自写文件\\论文插图第三波\\hazeroad_Kim_50.jpg", imOutput);
			}
			if (pos == 70)
			{
				cvSaveImage("F:\\自写文件\\论文插图第三波\\hazeroad_Kim_70.jpg", imOutput);
			}
			if (pos == 90)
			{
				cvSaveImage("F:\\自写文件\\论文插图第三波\\hazeroad_Kim_90.jpg", imOutput);
			}*/
		   
		
			
			char c = cvWaitKey(30);         //间隔33ms
		
			while (c == 32)                 //按下空格键暂停
			{
				c = cvWaitKey(0);
				if (c == 27)
					c = 1;
			}
			if (c == 27)                    //如果按下Esc键中断   对应ESC的ASCII
				break;
		

	}
    	cvReleaseVideoWriter(&writer);
		cvReleaseCapture(&capture); //释放视频空间
		cvDestroyAllWindows();    //销毁窗口
		
	/*处理图片
		
		
		
		
     
	 IplImage *imInput = cvLoadImage("F:\\i8.jpg", -1);//定义原始图像

	 int nWid = imInput->width; //atoi(argv[3]);
	 int nHei = imInput->height; //atoi(argv[4]);

	 IplImage* imOutput = cvCreateImage(cvGetSize(imInput), IPL_DEPTH_8U, 3);
	 cvNamedWindow("In", 0);
	 dehazing dehazingImg(nWid, nHei, 1, false, false, 5.0f, 1.0f, 40);

	 dehazingImg.ImageHazeRemoval(imInput,imOutput);
	 cvShowManyImages("In", 2, imInput, imOutput);
     
	 cvWaitKey(0);
	 cvReleaseImage(&imInput);
	 cvReleaseImage(&imOutput);
	 cvDestroyWindow("In");
	 */
		/*
argv[1] = "E:\\看见台湾.avi";
argv[2] = "E:\\看见台湾_removal.avi";
CvCapture* cvSequence = cvCaptureFromFile(argv[1]);

int nWid = (int)cvGetCaptureProperty(cvSequence,CV_CAP_PROP_FRAME_WIDTH); //atoi(argv[3]);
int nHei = (int)cvGetCaptureProperty(cvSequence,CV_CAP_PROP_FRAME_HEIGHT); //atoi(argv[4]);

cv::VideoWriter vwSequenceWriter(argv[2], 0, 25, cv::Size(nWid, nHei), true);

IplImage *imInput;
IplImage *imOutput = cvCreateImage(cvSize(nWid, nHei),IPL_DEPTH_8U, 3);

int nFrame;

dehazing dehazingImg(nWid, nHei, 16, false, false, 5.0f, 1.0f, 40);

time_t start_t = clock();

for( nFrame = 0; nFrame < atoi(argv[3]); nFrame++ )
{
imInput = cvQueryFrame(cvSequence);

dehazingImg.HazeRemoval(imInput,imOutput,nFrame);

vwSequenceWriter.write(imOutput);
}

cout << nFrame <<" frames " << (float)(clock()-start_t)/CLOCKS_PER_SEC << "secs" <<endl;

getch();

cvReleaseCapture(&cvSequence);
cvReleaseImage(&imOutput);
*/
		return 0;
	
}
