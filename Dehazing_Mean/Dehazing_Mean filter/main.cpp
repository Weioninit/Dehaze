//	Last updated: 2016-01-7
//	Author: zhenwei gao.
// */
//

#include <time.h>
#include <conio.h>
#include "dehazing.h"

CvCapture* capture = NULL;
using namespace std;
double Mean;                                                      //像素平均值
double A;
int pos = 0;  //视频位置 

void ON_Change(int n)
{
	cvSetCaptureProperty(capture, CV_CAP_PROP_POS_FRAMES, n);     //设置视频走到pos位置  
}
int main(int argc, char** argv)
{
	IplImage* rawImage = 0, *imInput;
	bool pause = false;
	bool singlestep = false;
	int c;
	double mean_value = 0., A_value_m=0.8, A_value_Mm=0.8;
	capture = cvCreateFileCapture("F:\\video_seq\\riverside.avi");//创建一个视频
	int nWid = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH);
	int nHei = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT);

	int frames = (int)cvGetCaptureProperty(capture, CV_CAP_PROP_FRAME_COUNT);        //返回视频帧的总数  
	int r = (int)max(nWid, nHei) / 80;

	IplImage *imOutput_Mm = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
	IplImage *imOutput_m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);

	IplImage *m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
	IplImage *m_ave = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);

	IplImage *M = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
	IplImage *M_ave = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);

	IplImage *L_Mm = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
	IplImage *L_m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
	if (capture && !(nWid % 2) && !(nHei % 2))
	{
		cvNamedWindow("Raw", 0);//原始视频图像
		cvNamedWindow("dehazing_Mm", 0);
//		cvNamedWindow("dehazing", 1);
		double sum_t = 0.0;
		int i = -1;
		cvCreateTrackbar("rawImage", "dehazing_Mm", &pos, frames, ON_Change);//创建滚动条  
		for (;;)
		{

			if (!pause) {
				double t = (double)cvGetTickCount();
				rawImage = cvQueryFrame(capture);
				++i;//count it
					//                printf("%d\n",i);
				if (!rawImage)
					break;
				/*处理过程*/
			//	cvCvtColor()
				mean_value = MinFilter(rawImage, m);
				mean_value = MaxMinFilter(rawImage, M, m);
//				cout << "Mean_value = " << mean_value << endl;
				cvSmooth(M, M_ave, CV_BLUR, r, r, 0, 0);
				cvSmooth(m, m_ave, CV_BLUR, r, r, 0, 0);
				cout << "r=" << r << endl;
//				cvShowImage("M_ave", M_ave);
//				cvShowImage("m_ave", m_ave);

//			    A_value_m = Cal_A(m, rawImage);
				A_value_Mm = Cal_A(m, rawImage);
				Cal_L_MaxMin(M_ave, m_ave, L_Mm, 1.3, mean_value, A_value_Mm);
//				Cal_L(m, m_ave, L_m, 1.3,mean_value);
//				A_value = 150.0;
				OutPut_Color( rawImage, L_Mm, imOutput_Mm, A_value_Mm);
//				OutPut_Color(rawImage, L_m, imOutput_m, A_value_m);
				t = (double)cvGetTickCount() - t;
				sum_t += t;
				printf("run time per frame = %gms\n", t / 1000);
				printf("average run time per frame = %gms\n", sum_t / (1000 * (i + 1)));
				//			}
				//display
				
//				cvShowManyImages("dehazing_Mm",2, rawImage,imOutput_Mm);
				cvShowImage("dehazing_Mm", imOutput_Mm);
				cvShowImage("Raw", rawImage);
//				cvShowImage("dehazing_m", imOutput_m);
				/*
				if(i==150)
				{
					cvSaveImage("C:\\Users\\振巍\\Desktop\\快速去雾实验图片\\cross_150_raw.png", rawImage);
				cvSaveImage("C:\\Users\\振巍\\Desktop\\快速去雾实验图片\\cross_150.png", imOutput_Mm);
				}*/
				cout << "A_value_m = "<<A_value_m << endl;
				cout << "A_value_Mm = " << A_value_Mm << endl;
				pos++;              //播放一帧位置加1
	//		    cvSetTrackbarPos("rawImage","show",pos);//设置进度条位置 加入此语句后视频会变卡
				//REMOVE THIS FOR GENERAL OPERATION, JUST A CONVIENIENCE WHEN RUNNING WITH THE SMALL tree.avi file
			}
			if (singlestep) {
				pause = true;
			}
			//First time:
			if (0 == i) {


			}
			//USER INPUT:
			c = cvWaitKey(30) & 0xFF;
			if (c == 27 || c == 'q' || c == 'Q')
				break;
			//Else check for user input
			switch (c)
			{
			case 'p':
				pause ^= 1;
				printf("average run time per frame = %gms\n", sum_t / (1000 * i));
				printf("%d\n", i);

				break;
			case 's':
				singlestep = 1;
				pause = false;
				break;
			case 'r':
				pause = false;
				singlestep = false;
				break;
			}

		}  //end of for
		cvReleaseCapture(&capture);
		cvDestroyWindow("Raw");
		cvDestroyWindow("dehazing");
		if (imOutput_Mm) cvReleaseImage(&imOutput_Mm);

	}//end of if
	else  cout << "The Input Image does not meet the requirements" << endl;
	return 0;
}
