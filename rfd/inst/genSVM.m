## -*- texinfo -*-
## @deftypefn {Function File} {[@var{svm},@var{lbl},@var{dsc}] =} genSVM (@var{conf}, @var{data}, @var{tr})
## Generate a support vector machine for the purposes of classifying Landsat data
## using training data.
##
## The output @var{svm} will be a support vector machine object for use
## with LIBSVM and svmpredict.
## 
## @var{lbl} and @var{dsc} will be, respectively, the labels and the radial
## Fourier descriptor vectors for the data points in @var{data} indicated by
## @var{tr}. These should be Nx1 and NxM respectively, where N is the number
## of training points selected.
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
## The Landsat @var{data} must be, in this case, provided as a one-dimensional
## cell array composed of 1x11 cell arrays filled with the Landsat data.
##
## The training data @var{tr} must be a cell array of the same dimensions as
## @var{data}, and must be populated with training matrices associated with
## the respective cell in @var{data}.
##
## @seealso{classifyimage}
## @end deftypefn

function [svm,svl,svd] = genSVM ( binConfig , im , tr )
    bands=[1:7,10,11];
    
    filt=find(binConfig.bands);
    localbands=bands(filt);
    
    normmat=0;
    for imscan=1:length(im)
    	printf(['sample ',num2str(imscan)]);
    	[svlp{imscan},svdp{imscan}]=labelRFDFullExtract(
    		tr{imscan} ,
    		im{imscan}(localbands) ,
    		binConfig.rbins(filt) ,
    		binConfig.sines(filt) ) ;
    end
    toc;
    
    svl=[]; svd=[];
    for imscan2=1:length(im)
    	svl=[svl;svlp{imscan2}];
    	svd=[svd;svdp{imscan2}];
    endfor
    
    classcount=[unique(svl),arrayfun(@(x) sum(svl==x),unique(svl))];
    if( max( classcount(:,2) ) > 3 * min( classcount(:,2) ) )
    	warning('Training data set highly imbalanced! Automatically undersampling!');
    	%For heavily imbalanced datasets, undersample the larger set.
    	minimum_class=min(classcount(:,2));
    	svd2=[];
    	svl2=[];
    	for class_label=unique(svl)'
    		list=find( svl == class_label );
    		[~,shufind]=sort(rand(1,length(list)));
    		svd2=[svd2;svd(list(shufind(1:min(end,minimum_class))),:)];
    		svl2=[svl2;svl(list(shufind(1:min(end,minimum_class))))];
    	endfor
    	svd=svd2;
    	svl=svl2;
    endif
    
    printf([mat2str(size(svd)),'\n']);
    opt=['-h 0 -q -w128 ',num2str(binConfig.costs(1)),' -w255 ',num2str(binConfig.costs(2))];
    svm = svmtrain(double(svl),double(svd),opt);
endfunction
