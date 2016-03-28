function varargout = svmRFDExtract( varargin )
% svmRFDExtract (im[, tr, 'radius', RADIUS, 'point', POINT, 'rbins', RBINS, 'sines', SINES, 'array'])
    if(nargin<1);
        print_usage;
    endif
    p=inputParser();
    p.FunctionName='svmRFDExtract';
    p.addRequired('imRawData',@iscell);
    p.parse(varargin{1});
    imRawData=p.Results.imRawData ;
    defpoint=round(size(imRawData{1})/2);
    for layer=1:length(imRawData);
        defrbins{layer}=[0;10];
    endfor
    defsines=8*ones(size(imRawData)) ;
    p.addOptional('imTraining',[],@isnumeric);
    p.addParamValue('radius',inf,@isnumeric);
    p.addParamValue('point',defpoint,@isnumeric);
    p.addParamValue('rbins',defrbins,@iscell);
    p.addParamValue('sines',defsines,@isnumeric);
    p.addSwitch('array');

    p.parse(varargin{:});
    
    imTraining=p.Results.imTraining ; 
    imRawData=p.Results.imRawData ;
    radius=p.Results.radius ;
    point=p.Results.point ;
    rbins=p.Results.rbins ;
    sines=p.Results.sines ;
    ret3darray=p.Results.array ;

	h=[];
	for layer=1:length(rbins)
        if( radius < inf)
    		mmrl=ceil(max(max(rbins{layer})));
        else
            mmrl=0;
        endif
		for rbin=rbins{layer};
			newbatch=RadialFourierDescriptor(rbin',neighborhood(imRawData{layer},point,radius+mmrl),sines(layer));
			if( radius < inf )
                newbatch=newbatch((1+mmrl):(end-mmrl),(1+mmrl):(end-mmrl),:);
            endif
			h=cat(3,h,newbatch);
		endfor
	endfor
    
    if( ret3darray )
        varargout{1}=h;
        return
    endif

	nbhd=neighborhood(imTraining,point,radius);
	
	pile=cat(3,nbhd,h);
	pile=permute(pile,[3,1,2])(:,:)';
	
	index=find(pile(:,1) ~= 0);
	
	varargout{1}=pile(index,1);
	varargout{2}=pile(index,2:end);
endfunction
