///*
//	The main function is an example of video dehazing 
//	The core algorithm is in "dehazing.cpp," "guidedfilter.cpp," and "transmission.cpp". 
//	You may modify the code to improve the results.
//
//	The detailed description of the algorithm is presented
//	in "http://mcl.korea.ac.kr/projects/dehazing". See also 
//	J.-H. Kim, W.-D. Jang, Y. Park, D.-H. Lee, J.-Y. Sim, C.-S. Kim, "Temporally
//	coherent real-time video dehazing," in Proc. IEEE ICIP, 2012.
//
//	Last updated: 2013-02-14
//	Author: Jin-Hwan, Kim.
// */
//
//#include "dehazing.h"
//#include <time.h>
//#include <conio.h>
//
//int main(int argc, char** argv)
//{	
//	IplImage *imInput = cvLoadImage("H:\\桌面\\color-line截距直方图\\sweden_1.jpg", -1);
//	
//	int nWid = imInput->width;
//	int nHei = imInput->height;
//	
//	IplImage *imOutput = cvCreateImage(cvSize(nWid, nHei),IPL_DEPTH_8U, 3);
//
////	dehazing dehazingImg(nWid, nHei, 30, false, false, 5.0f, 1.0f, 40);
//	dehazing dehazingImg(nWid, nHei, 1, false, false, 5.0f, 1.0f, 60);
//	//dehazingImg.ImageHazeRemoval(imInput, imOutput);
//	//dehazingImg.ImageHazeRemovalYUV(imInput, imOutput);
//	dehazingImg.ImageHazeRemoval(imInput, imOutput);
//	cvSaveImage("C:\\Users\\振巍\\Desktop\\毕业论文figure\\主观对比图和定量评价\\sweden_kim.png", imOutput);
////	cvSaveImage(argv[2], imOutput);
//
////	_getch();
//
//	cvReleaseImage(&imInput); 
// 	cvReleaseImage(&imOutput);
//	
//	return 0;
//}
//
