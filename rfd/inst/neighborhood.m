% Neighborhood
function varargout = neighborhood (array, point, radius)
	if( radius < 0 )
		error('Radius must be nonnegative!')
	end
	radius=round(radius);
	xMin=max( point(1)-radius , 1 );
	xMax=min( point(1)+radius , size(array,1) );
	yMin=max( point(2)-radius , 1 );
	yMax=min( point(2)+radius , size(array,2) );
	varargout{1}=double(array(xMin:xMax, yMin:yMax));
    varargout{2}{1}=[xMin:xMax];
    varargout{2}{2}=[yMin:yMax];
end
