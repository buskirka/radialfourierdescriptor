## -*- texinfo -*-
## @deftypefn {Function File} {@var{RFD} =} RadialFourierDescriptor (@var{radius}, @var{im})
## @deftypefn {Function File} {@var{RFD} =} RadialFourierDescriptor (@var{radius}, @var{im}, [@var{sines}])
## Computes a descriptor vector for the image based on the discrete Fourier 
## transform.
##
## The return, @var{RFD}, will generally be a 3-dimensional array 
## the size MxNx@var{sines}, where [@var{M},@var{N}]==size(@var{im}).
##
## @var{radius} must be a scalar or a 1x2 matrix. In the former case,
## the 1x2 matrix [0,@var{radius}] is used instead of @var{radius} itself.
## The two entries indicate the inner and outer radii of the annuloid 
## sectors which will be utilized in the FFT.
##
## @var{im} must be a matrix and should contain a grayscale image to be
## described.
##
## @var{sines} is a positive integer greater than 1, and describes how
## many terms of the FFT should be retained. It is optional, and defaults
## to 20.
##
## @seealso{genSVM, labelRFDFullExtract, classifyimage}
## @end deftypefn
function featurearray = RadialFourierDescriptor ( radius , im , sinusoids = 20 )
	
	if(size(radius)==[1,1])
		radius(2)=radius(1);
		radius(1)=0;
	elseif(size(radius)==[1,2])
		%All's well
	else
		error('`radius` must be a 1x1 or 1x2 vector.');
	endif

	% First we need to determine a sensible number of angular bins to divide the
	% annulus into to discretize the system. In this case, we approximate this
	% with the standard pi*r^2 equation, and subtract 1 for the center pixel.
	number_of_cells=pi*(radius(2)+0.5)^2-pi*(radius(1)+0.5)^2;
	bins = max([4,[8,16,32] .* ([8,16,32]<number_of_cells/25)]);
	
	center=[radius(2)+1,radius(2)+1];
	anglemat=atan2(repmat((radius(2):-1:-radius(2))',1,2*radius(2)+1),repmat(-radius(2):radius(2),2*radius(2)+1,1));
	distmat=sqrt(repmat((radius(2):-1:-radius(2))',1,2*radius(2)+1).^2 + repmat(-radius(2):radius(2),2*radius(2)+1,1).^2);
	% For each of those bins,
	for bin=1:bins;
		% We construct a convolution matrix for this particular layer.
		convmat = (radius(1) <= distmat) .* ...
				( distmat <= radius(2)) .* ...
				( 2*pi*(bin-1)/bins-pi <= anglemat ) .* ...
				( anglemat <= 2*pi*bin/bins - pi );
		if(sum(sum(convmat))>0)
			convmat /= sum(sum(convmat));
		endif
		if(bin==1)
			subconv=conv2(im,convmat,'same');
		else
			subconv=cat(3,subconv,conv2(im,convmat,'same'));
		endif
	endfor
	list=(fft(subconv,size(subconv,3),3))(:,:,1:min(sinusoids,1+bins/2));
	featurearray=abs(list);
endfunction 
