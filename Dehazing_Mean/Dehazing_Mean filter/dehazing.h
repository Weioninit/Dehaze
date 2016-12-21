#include <opencv2\contrib\contrib.hpp>
#include <opencv\cv.h>  
#include <opencv\highgui.h> 
#include <time.h>
#include <conio.h>
#include <omp.h>
#define CLIP_Z(x) ((x)<(0)?0:((x)>(1.0f)?(1.0f):(x)))
#define CLIP(x) ((x)<(0)?0:((x)>(255)?(255):(x)))
#define CLIP_Fi(x) ((x)<(0.65)?0.65:((x)>(0.93)?(0.93):(x)))
#define max(x,y)  ( x>y?x:y )
#define min(x,y)  ( x>y?y:x )
using namespace std;

void DrawColorMap(IplImage *ImgInPut, int Color);
unsigned char * MakeLUT(double InvA);
double MinFilter(IplImage *img, IplImage* dst);
double MaxMinFilter(IplImage *img, IplImage* dst1, IplImage* dst2);
void Cal_L(IplImage *M, IplImage * M_ave, IplImage *L, double rou, double Mean);
void Cal_L_MaxMin(IplImage *M, IplImage * m, IplImage *L, double rou, double Mean, double A);
double Cal_A(IplImage* M_ave, IplImage * H);
void OutPut_Color(IplImage *H, IplImage *L, IplImage * Output, double A);
void cvShowManyImages(char * title, int nArgs, ...);
uchar IplImageToInt(IplImage* imInput, unsigned char *m_pnYImg);
double * MakeRatioLUT(uchar mean_Y, unsigned char *m_pnYImg, int m_nHei, int m_nWid);

void Cal_L_MaxMin_val(IplImage* H, IplImage *M, IplImage * m, IplImage *L, double A);