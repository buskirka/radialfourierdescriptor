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
