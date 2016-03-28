function classy = classifyimage(svm,DataCells,binConfig)
	svl=[]; 
	svd=[]; 
	fflush(stdout); 
	pile=svmRFDExtract(
        DataCells,
        'rbins',binConfig.rbins,
        'sines',binConfig.sines,
        'array'); 
    classy=[];
    for y=1:size(pile,2)
        dat=pile(:,y,:);
        dat=permute(dat,[1,3,2]);
        fakel=zeros(size(dat,1),1);
        predline=svmpredict( double(fakel), double(dat), svm, '-q');
        classy=[classy;predline];
    endfor
endfunction
