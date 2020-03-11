function[Geom]= elem_coord(Geom)
%**********************************************************************************************
% SCRIPTFILE NAME:   ELEMCOORD.M (for 2D-Frame, Grid and 3D-Frame structures)
%
% MAIN FILE      :   CASAP
%
% Description    :   This file assembles a matrix, elemcoor which contains the coordinates
%                   of the first and second nodes on each element, respectively.
%
%**********************************************************************************************

%   ASSEMBLE THE ELEMENT COORDINATE MATRIX, ELEMCOOR FROM NODECOOR AND LNODS

for ielem = 1 : Geom.nelem
   if Geom.istrtp == 3   
    Geom.elemcoor(ielem,:) = [Geom.nodecoor(Geom.lnods(ielem,1),:),...
        Geom.nodecoor(Geom.lnods(ielem,2),:)];
   
   elseif Geom.istrtp == 4   
    Geom.elemcoor(ielem,:) = [Geom.nodecoor(Geom.lnods(ielem,1),:),...
        Geom.nodecoor(Geom.lnods(ielem,2),:)];
   
   elseif Geom.istrtp == 6   
    Geom.elemcoor(ielem,:) = [Geom.nodecoor(Geom.lnods(ielem,1),:),...
        Geom.nodecoor(Geom.lnods(ielem,2),:)];
   end
end
end

