#include <Rcpp.h>
#include <fstream>
#include <string>
#include <stdlib.h>  
#include <stdio.h>  
#include <math.h>  
#include <cv.h>  
#include <highgui.h> 

RcppExport SEXP readData(SEXP f1) {
    std::string fname = Rcpp::as<std::string>(f1); 
    std::ifstream fi;
    fi.open(fname.c_str(),std::ios::in);
    IplImage* img = 0;   
    int height,width,step,channels;  
    uchar *data;  
    int i,j,k;  
    // Load image   
    img=cvLoadImage(argv[1],-1);  
    if(!img)  
    {  
        printf("Could not load image file: %s\n",argv[1]);  
        exit(0);  
    }  
    // acquire image info  
    height    = img->height;    
    width     = img->width;    
    step      = img->widthStep;    
    channels  = img->nChannels;  
    data      = (uchar *)img->imageData;  
    // reverse image 
    for(i=0;i<height;i++)   
        for(j=0;j<width;j++)   
            for(k=0;k<channels;k++)  
                data[i*step+j*channels+k]=255-data[i*step+j*channels+k];  
    imwrite("test.bmp", img);    
    Rcpp::CharacterVector rline = Rcpp::wrap('test.bmp');
    return rline;
}
