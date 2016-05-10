## -*- texinfo -*-
## @deftypefn {Function File} {@var{I} =} classifyimage (@var{svm}, @var{data}, @var{conf})
## @deftypefnx {Function File} {@var{I} =} classifyimage (@var{svm}, @var{data}, @var{conf}, [@var{pics}])
## Classify a Landsat scene using the radial Fourier descriptor 
## associated with the configuration @var{conf} associated with the 
## support vector machine @var{svm} from the data set @var{data}.
##
## The return image @var{I} will be a matrix the same size as the 
## Landsat scene composed of the classes predicted by @var{svm}.
##
## The support vector machine @var{svm} is an object produced by 
## svmtrain, which may be accessed through the genSVM command.
##
## The Landsat @var{data} to be classified must be provided as a 1x11 
## cell array
## of matrices all of identical dimensions, which should furthermore
## correspond to the @var{conf} provided.
##
## The configuration @var{conf} must be a struct possessing @var{rbins},
## @var{sines}, @var{costs}, and @var{bands}. @var{rbins} must be a
## 1x11 cell array whose members are 2xN matrices nonnegative and
## strictly increasing in the first dimension, describing which 
## annuloid sectors are to be processed. @var{sines} must be a 
## 1x11 matrix consisting of integers greater than 1 (and preferably higher),
## describing how many of the terms of the FFT should be retained.
## @var{costs} must be a 1x2 matrix of floats greater than 0. @var{bands}
## must be a 1x11 matrix, where each nonzero entry indicates that the
## respective band should be taken.
##
## @var{pics} is an optional boolean option; if true, the classification 
## image will be shown as it is constructed.
##
## @seealso{genSVM}
## @end deftypefn

function classy = classifyimage(svm,DataCells,binConfig,pics=false)
	svl=[]; 
	svd=[]; 
    classy=[];
	fflush(stdout); 
    radius=400;
    bands=[1:7,10,11];
    filt=find(binConfig.bands);
    localbands=bands(filt);
	for i=(2*radius):(2*radius):(size(DataCells{1},1)-(2*radius)); 
		for j=(2*radius):(2*radius):(size(DataCells{1},2)-(2*radius)); 
            [~,sizes]=neighborhood(DataCells{1},[i,j],radius);
        	pile=svmRFDExtract(
                DataCells(localbands),
                'rbins',binConfig.rbins(filt),
                'sines',binConfig.sines(filt),
                'radius',radius,
                'point',[i,j],
                'array'); 
            printf(mat2str(size(pile)));
            classymini=[];
            dat=[];
            fakel=[];
            for y=1:size(pile,2)
                datt=pile(:,y,:);
                datt=permute(datt,[1,3,2]);
                fakelt=zeros(size(datt,1),1);
                dat=[dat;datt];
                fakel=[fakel;fakelt];
                printf('.'); fflush(stdout);
            endfor
            printf(' * ');
            predline=svmpredict( double(fakel), double(dat), svm);
            classymini=reshape(predline,size(pile,1),size(pile,2));
            classy(sizes{1},sizes{2})=classymini ;
            printf(':');
            if(pics==true)
                imshow(classy);
                sleep(0.001);
            endif
        endfor
    endfor
endfunction
