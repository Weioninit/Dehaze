//#include "dehazing.h"
//#include <time.h>
//#include <conio.h>
//
//int main(int argc, char** argv)
//{	
//	IplImage *rawImage = cvLoadImage("C:\\Users\\振巍\\Desktop\\毕业论文figure\\平台运行速度\\snapshot20161215162407.jpg", -1);  // the input image should be divisible by 2 on width and height
//
//	int nWid = rawImage->width;
//	int nHei = rawImage->height;
//	int r = (int)min(nWid, nHei) / 80;
//	
//	double mean_value = 0., A_value = 0.8;
//	IplImage *imOutput_Mm = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
//	IplImage *imOutput_m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
//	IplImage *imOutput_val = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
//
//	IplImage *m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	IplImage *m_ave = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	IplImage *test_m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 3);
//
//	IplImage *M = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	IplImage *M_ave = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//
//	IplImage *L_Mm = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	IplImage *L_m = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	IplImage *L_val = cvCreateImage(cvSize(nWid, nHei), IPL_DEPTH_8U, 1);
//	double t = (double)cvGetTickCount();
//	
//	mean_value = MaxMinFilter(rawImage, M, m);
//	DrawColorMap(m, 2);
////	cvShowImage("m", m);
////	cout << "Mean_Min = " << mean_value << endl;
//	cvSmooth(M, M_ave, CV_BLUR, r, r, 0, 0);
//	cvSmooth(m, m_ave, CV_BLUR, r, r, 0, 0);
////	cout << "r=" << r << endl;
////					cvShowImage("M_ave", M_ave);
////					cvShowImage("m_ave", m_ave);
//	A_value = Cal_A(m, rawImage);
////	A_value = 150;
//	Cal_L_MaxMin(M_ave, m_ave, L_Mm, 1.3, mean_value, A_value);
//	Cal_L_MaxMin_val(rawImage, M, m, L_val, A_value);
//
//	/*画伪彩色图*/
///*	cv::Mat mt1(L_Mm);
//	cv::Mat mt2;
//	cv::applyColorMap(mt1, mt2, 2);
//	IplImage ImgOuput_img = mt2;
//	cvShowImage("L_Mm", &ImgOuput_img);
//
//	cv::Mat mtx(L_val);
//	cv::Mat mty;
//	cv::applyColorMap(mtx, mty, 2);
//	IplImage ImgOuput_img2 = mty;
//	cvShowImage("L_val", &ImgOuput_img2);
//
//*/
//	
//
//	Cal_L(m, m_ave, L_m, 1.3, mean_value);
////					A_value = 150.0;
//
//	OutPut_Color(rawImage, L_Mm, imOutput_Mm, A_value);
////	OutPut_Color(rawImage, L_val, imOutput_val, A_value);
////	OutPut_Color(rawImage, L_m, imOutput_m, A_value);
//	t = (double)cvGetTickCount() - t;
//
//	printf("run time per frame = %gms\n", t / 1000);
//	
//				
//	//display
//
//	cvShowImage("raw", rawImage);
//	cvShowImage("dehazing_Mm", imOutput_Mm);
////	cvShowImage("L_Mm", L_Mm);
////	cvShowImage("dehazing_val", imOutput_val);
////					cvShowImage("m", m);
////	cvSaveImage("C:\\Users\\振巍\\Desktop\\color-line截距直方图\\snow_gao.png", imOutput_Mm);
//
//
////	cout << "A_value = " << A_value << endl;
//	cvWaitKey(-1);
//	cvReleaseImage(&imOutput_Mm);
//	cvReleaseImage(&imOutput_m);
//	
//	return 0;
//}