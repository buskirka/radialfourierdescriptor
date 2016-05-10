## -*- texinfo -*-
## @deftypefn {Function File} {[@var{lbl},@var{dsc}] =} labelRFDFullExtract (@var{tr}, @var{data}, @var{rbins}, @var{sines})
## Extracts the radial Fourier descriptor for a scene from data.
##
## Two objects are returned, @var{lbl} and @var{dsc}. They are Nx1 and NxM matrices 
## respectively, where N is the number of pixels indicated in @var{tr} and M is the
## length of the descriptor vector specified through @var{rbins} and @var{sines}.
## @var{lbl} encodes the labels associated with the radial Fourier descriptor
## vectors in @var{dsc}.
## 
## @var{tr} is a matrix filled with nonnegative 
## training labels, where a value of zero indicates
## that the point should be ignored.
##
## @end deftypefn
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
