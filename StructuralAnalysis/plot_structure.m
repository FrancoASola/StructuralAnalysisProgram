%************************************************************************************************
function plot_structure(Geom)
%	Description		:	This file will draw a 2D or 3D structure (1D structures are generally
%						boring to draw).
%
%	Input Variables	:	nodecoor 	- nodal coordinates
%						ID			- connectivity matrix
%						drawflag	- flag for performing drawing routine
%
%	By Dean A. Frank
%	CVEN 5525
%	Advanced Structural Analysis - Term Project
%	Fall 1995
%
%	(with thanks to Brian Rose for help with this file)
%
%************************************************************************************************
istrtp=Geom.istrtp;
npoin=Geom.npoin;
orig_ID=Geom.orig_ID;
lnods=Geom.lnods;
nodecoor=Geom.New_nodecoor;


%	PERFORM OPERATIONS IN THIS FILE IF DRAWFLAG = 1

	if istrtp==1
		drawtype=2;
	elseif istrtp==2
		drawtype=2;
	elseif istrtp==3
		drawtype=2;
	elseif istrtp==4
		drawtype=2;
	elseif istrtp==5
		drawtype=3;
	elseif istrtp==6
		drawtype=3;
	else
		error('Incorrect structure type in indat.m')
    end

	ID=orig_ID.';

	%	DRAW 2D STRUCTURE IF DRAWTYPE=2
	if drawtype==2

		%	RETRIEVE NODAL COORDINATES
		x=nodecoor(:,1);
		y=nodecoor(:,2);

		%   IF BEAM, MODIFY ID MATRIX
        if istrtp==1         
            for ipoin=1:npoin
                if ID(1:2,ipoin)==[0;0]
                        ID(1:3,ipoin)=[0;0;0];
                elseif ID(1:2,ipoin)==[0;1]
                    ID(1:3,ipoin)=[1;0;1];
                elseif ID(1:2,ipoin)==[1;1]
                    ID(1:3,ipoin)=[1;1;1];
                elseif ID(1:2,ipoin)==[1;0]
                    ID(1:3,ipoin)=[0;1;0];
                end
            end
        end
        
        %   IF 2D-TRUSS, MODIFY ID MATRIX
		if istrtp==2
			for ipoin=1:npoin
				if ID(1:2,ipoin)==[0;0]
					ID(1:3,ipoin)=[0;0;0];
				elseif ID(1:2,ipoin)==[0;1]
					ID(1:3,ipoin)=[0;1;0];
				elseif ID(1:2,ipoin)==[1;1]
					ID(1:3,ipoin)=[1;1;0];
				end
			end
		end
	
		%	IF GRID, SET ID=ZEROS
  		if istrtp==4
    		ID=ID*0;
  		end
	
		%	SET UP FIGURE
        
		handle=figure;
		margin=max(max(x)-min(x),max(y)-min(y))/10;
		axis([min(x)-margin, max(x)+margin, min(y)-margin, max(y)+margin])
		axis('equal')
		hold on

		%	CALC NUMBER OF NODES, ETC.
        
		number_nodes=length(x);
		number_elements=size(lnods,1);
		number_fixities=size(ID,2);
		axislimits=axis;
		circlesize=max(axislimits(2)-axislimits(1),axislimits(4)-axislimits(3))/40;

		%	DRAW SUPPORTS
        
		for i=1:number_fixities

  			%	DRAW HORIZ. ROLLER
            
  			if ID(:,i)==[0 1 0]'
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i),cos(0:0.1:pi*2)*circlesize/2-circlesize/2+y(i),'r')

  			%	DRAW PIN SUPPORT
            
  			elseif ID(:,i)==[1 1 0]' 
   				plot([x(i),x(i)-circlesize,x(i)+circlesize,x(i)],[y(i),y(i)-circlesize,y(i)-circlesize,y(i)],'r')

  			%	DRAW HORIZ. ROLLER SUPPORT

			elseif ID(:,i)==[0 1 1]'
    			plot([x(i)+circlesize*2,x(i)-circlesize*2],[y(i),y(i)],'r');
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i),cos(0:0.1:pi*2)*circlesize/2-circlesize/2+y(i),'r')
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i)+circlesize,cos(0:0.1:pi*2)*circlesize/2-circlesize/2+y(i),'r')
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i)-circlesize,cos(0:0.1:pi*2)*circlesize/2-circlesize/2+y(i),'r')

 			%	DRAW VERT. ROLLER SUPPORT

  			elseif ID(:,i)==[1 0 0]'
   				plot(sin(0:0.1:pi*2)*circlesize/2+x(i)-circlesize*.5,cos(0:0.1:pi*2)*circlesize/2,'r')

  			%	DRAW ROLLER SUPPORT WITH NO ROTATION

  			elseif ID(:,i)==[1 0 1]'
   				plot([x(i),x(i)],[y(i)+circlesize*2,y(i)-circlesize*2],'r');
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i)-circlesize*.5,cos(0:0.1:pi*2)*circlesize/2,'r')
   				plot(sin(0:0.1:pi*2)*circlesize/2+x(i)-circlesize*.5,cos(0:0.1:pi*2)*circlesize/2+circlesize,'r')
    			plot(sin(0:0.1:pi*2)*circlesize/2+x(i)-circlesize*.5,cos(0:0.1:pi*2)*circlesize/2-circlesize,'r')
 			end

 			%	DRAW HORIZ. PLATFORM

  			if min(ID(:,i)==[0 1 0]') |  min(ID(:,i)==[1 1 0]')  | min(ID(:,i)==[0 1 1]')  
   	 			plot([x(i)-circlesize*2,x(i)+circlesize*2],[y(i)-circlesize,y(i)-circlesize],'r')
   				plot([x(i)-circlesize*1.5,x(i)-circlesize*2],[y(i)-circlesize,y(i)-circlesize*1.5],'r')
    			plot([x(i)-circlesize*1,x(i)-circlesize*2],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)-circlesize*.5,x(i)-circlesize*1.5],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*0,x(i)-circlesize*1],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*.5,x(i)-circlesize*(0.5)],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*1,x(i)+circlesize*0],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*1.5,x(i)+circlesize*.5],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*2,x(i)+circlesize*1],[y(i)-circlesize,y(i)-circlesize*2],'r')
    			plot([x(i)+circlesize*2,x(i)+circlesize*1.5],[y(i)-circlesize*1.5,y(i)-circlesize*2],'r')

  			%	DRAW FIXED SUPPORT

  			elseif ID(:,i)==[1 1 1]'
    			plot([x(i)-circlesize*2,x(i)+circlesize*2],[y(i)-circlesize,y(i)-circlesize]+circlesize,'r')
    			plot([x(i)-circlesize*1.5,x(i)-circlesize*2],[y(i)-circlesize,y(i)-circlesize*1.5]+circlesize,'r')
    			plot([x(i)-circlesize*1,x(i)-circlesize*2],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)-circlesize*.5,x(i)-circlesize*1.5],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*0,x(i)-circlesize*1],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*.5,x(i)-circlesize*(0.5)],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*1,x(i)+circlesize*0],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*1.5,x(i)+circlesize*.5],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*2,x(i)+circlesize*1],[y(i)-circlesize,y(i)-circlesize*2]+circlesize,'r')
	    		plot([x(i)+circlesize*2,x(i)+circlesize*1.5],[y(i)-circlesize*1.5,y(i)-circlesize*2]+circlesize,'r')

  			%	DRAW VERT. PLATFORM

  			elseif  min(ID(:,i)==[1 0 0]') | min(ID(:,i)==[1 0 1]')
    			xf=[x(i)-circlesize,x(i)-circlesize*2];
	    		yf=[y(i),y(i)- circlesize];
	    		plot(xf,yf,'r')
	   	 		plot(xf,yf+circlesize*.5,'r')
	    		plot(xf,yf+circlesize*1,'r')
	    		plot(xf,yf+circlesize*1.5,'r')
	    		plot(xf,yf+circlesize*2,'r')
	    		plot([x(i)-circlesize*1.5,x(i)-circlesize*2],[y(i)+circlesize*2,y(i)+ circlesize*1.5],'r')
	    		plot(xf,yf-circlesize*.5,'r')
	    		plot(xf,yf-circlesize*1,'r')
	   			plot([x(i)-circlesize,x(i)-circlesize*1.5],[y(i)-circlesize*1.5,y(i)- circlesize*2],'r')
	    		plot([xf(1),xf(1)],[y(i)+circlesize*2,y(i)-circlesize*2],'r');
  			end
		end

		%	DRAW ELEMENTS

		for i=1:number_elements
  			plot([x(lnods(i,1)),x(lnods(i,2))],[y(lnods(i,1)),y(lnods(i,2))],'b');
  			if i==1
  			end
		end

		%	DRAW JOINTS

		for i=1:number_nodes
  			if ~max(ID(:,i))
    			plot(x(i),y(i),'mo')
  			end
		end

		%	DRAW ELEMENT NUMBERS

		for i=1:number_elements
  			set(handle,'DefaultTextColor','blue')
  			text(  (x(lnods(i,1))+x(lnods(i,2)))/2+circlesize,(y(lnods(i,1))+y(lnods(i,2)))/2+circlesize,int2str(i))
		end

		%	DRAW JOINT NUMBERS

 		for i=1:number_nodes
  			set(handle,'DefaultTextColor','magenta')
  			text(x(i)+circlesize,y(i)+circlesize,int2str(i))
		end

		if exist('filename')
  			title(filename)
		end

		hold off
		set(handle,'DefaultTextColor','white')

	%	DRAW 3D STRUCTURE IF DRAWTYPE=3

	elseif drawtype==3

		%	RETREIVE NODE COORIDINATES

		x=nodecoor(:,1);
		y=nodecoor(:,2);
		z=nodecoor(:,3);

		%	SET UP FIGURE

		handle=figure;
		margin=max([max(x)-min(x),max(y)-min(y),max(z)-min(z)])/10;
		axis([min(x)-margin, max(x)+margin, min(y)-margin, max(y)+margin, min(z)-margin, max(z)+margin])
		axis('equal')
		hold on

		%	RETREIVE NUMBER OF NODES, ETC.

		number_nodes=length(x);
		number_elements=size(lnods,1);
		axislimits=axis;
		circlesize=max([axislimits(2)-axislimits(1),axislimits(4)-axislimits(3),axislimits(6)-axislimits(5)])/40;

		%	DRAW ELEMENTS

		for i=1:number_elements
  			plot3([x(lnods(i,1)),x(lnods(i,2))],[y(lnods(i,1)),y(lnods(i,2))],[z(lnods(i,1)),z(lnods(i,2))],'b');
		end

		%	DRAW JOINTS

		for i=1:number_nodes
  			plot3(x(i),y(i),z(i),'mo')
		end

		%	DRAW ELEMENT NUMBERS

		for i=1:number_elements
  			set(handle,'DefaultTextColor','blue')
  			text(  (x(lnods(i,1))+x(lnods(i,2)))/2+circlesize,(y(lnods(i,1))+y(lnods(i,2)))/2+circlesize,(z(lnods(i,1))+z(lnods(i,2)))/2+circlesize,int2str(i))
		end

		%	DRAW JOINT NUMBERS

 		for i=1:number_nodes
  			set(handle,'DefaultTextColor','magenta')
  			text(x(i)+circlesize,y(i)+circlesize,z(i)+circlesize,int2str(i))
		end

		if exist('filename')
  			title(filename)
		end

		xlabel('x')
		ylabel('y')
		zlabel('z')
        grid on

		%	DRAW GROUND

		X=x;
		Y=y;
		Z=z;
		X=axislimits(1)-margin:margin:axislimits(2)+margin;
		Y=axislimits(3)-margin:margin:axislimits(4)+margin;
		Z=zeros(length(X),length(Y));
		%mesh(X,Y,Z)
		size(X)
		size(Y)
		size(Z)

		hold off
		set(handle,'DefaultTextColor','white')

		hAZ=uicontrol('style','slider','position',[.7 .95 .3 .05],'units','normalized','min',0,'max',360,...
		'callback','[az,el]=view; az=get(gco,''val''); view(az,el);');

		hEL=uicontrol('style','slider','position',[.7 .89 .3 .05],'units','normalized','min',0,'max',180,...
		'callback','[az,el]=view; el=get(gco,''val''); view(az,el);');

		hdef=uicontrol('style','pushbutton','callback','view(-37.5, 30)','position',[.88 .83 .12 .05],'units','normalized','String','Default')

		%set(handle,'units','normalized')
		%text(.68,.95,'azimuth')
		%text(.68,.89,'elevation')
    end
    grid;
end












