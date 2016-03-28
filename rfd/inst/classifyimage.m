function classy = classifyimage(svm,DataCells,binConfig)
	svl=[]; 
	svd=[]; 
    classy=[];
	fflush(stdout); 
	for i=200:200:(size(DataCells{1},1)-200); 
		for j=200:200:(size(DataCells{1},2)-200); 
            [~,sizes]=neighborhood(DataCells{1},[i,j],100);
        	pile=svmRFDExtract(
                DataCells,
                'rbins',binConfig.rbins,
                'sines',binConfig.sines,
                'radius',100,
                'point',[i,j],
                'array'); 
            classymini=[];
            for y=1:size(pile,2)
                dat=pile(:,y,:);
                dat=permute(dat,[1,3,2]);
                fakel=zeros(size(dat,1),1);
                predline=svmpredict( double(fakel), double(dat), svm, '-q');
                classymini=[classymini;predline'];
                printf('.'); fflush(stdout);
            endfor
            classy(sizes{1},sizes{2})=classymini ;
            printf(':');
        endfor
    endfor
endfunction
