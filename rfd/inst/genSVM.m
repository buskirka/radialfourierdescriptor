function svm = genSVM ( binConfig , im , tr )
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
    	normmat=max(normmat,max(svdp{imscan}));
    end
    normmat=diag(1./normmat);
    for imscan=1:length(im)
    	svdp{imscan}=svdp{imscan}*normmat;
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
