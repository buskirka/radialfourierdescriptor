function [svl,svd] = labelRFDFullExtract(DataTraining,DataCells,rbins,sinusoidsCell)
	svl=[]; 
	svd=[]; 
	%printf(['\nlabelRFDFullExtract:']); 
	for i=200:200:(size(DataCells{1},1)-200); 
		for j=200:200:(size(DataCells{1},2)-200); 
			if(max(max(neighborhood(DataTraining,[i,j],100))) > 0); 
				%printf(['(',num2str(i),',',num2str(j),') ']); 
				fflush(stdout); 
				[l,d]=svmRFDExtract(
                    DataCells,
                    DataTraining,
                    'radius',100,
                    'point',[i,j],
                    'rbins',rbins,
                    'sines',sinusoidsCell); 
				svl=[svl;l]; 
				svd=[svd;d];
			endif
		endfor
		printf('.'); 
	endfor
endfunction
