function [Geom]=element_geometry(Geom)
%**********************************************************************************************
%   Scriptfile name :   length3.m   (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       When this file is called, it computes the length of each element and the
%       angle alpha between the local and global x-axes.  This file can be used
%       for 2-dimensional elements such as 2-D truss, 2-D frame, and grid elements.
%       This information will be useful for transformation between local and global
%       variables.
%
%   Variable descriptions:  (in the order in which they appear)
%
%       nelem               =   number of elements in the structure
%       ielem               =   counter for loop
%       L(ielem)            =   length of element ielem
%       elemcoor(ielem,3)   =   xj-coordinate of element ielem
%       elemcoor(ielem,1)   =   xi-coordinate of element ielem
%       elemcoor(ielem,4)   =   yj-coordinate of element ielem
%       elemcoor(ielem,2)   =   yi-coordinate of element ielem
%       alpha(ielem)        =   angle between local and global x-axes
%
%**********************************************************************************************

%   COMPUTE THE LENGTH AND ANGLE BETWEEN LOCAL AND GLOBAL X-AXES FOR EACH ELEMENT

for ielem = 1 : Geom.nelem
   if Geom.istrtp == 3  
    Geom.L(ielem)= sqrt((Geom.elemcoor(ielem,3)-Geom.elemcoor(ielem,1))^2+...
        (Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,2))^2);
    
Geom.alpha(ielem)= atan2((Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,2))...
            ,(Geom.elemcoor(ielem,3)-Geom.elemcoor(ielem,1)));
   
   elseif Geom.istrtp == 4  
    Geom.L(ielem)= sqrt((Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,1))^2+...
        (Geom.elemcoor(ielem,6)-Geom.elemcoor(ielem,3))^2);
    
Geom.alpha(ielem)= atan2((Geom.elemcoor(ielem,6)-Geom.elemcoor(ielem,3))...
            ,(Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,1)));
        
   elseif Geom.istrtp == 6 
    Geom.L(ielem)= sqrt((Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,1))^2+...
        (Geom.elemcoor(ielem,5)-Geom.elemcoor(ielem,2))^2+...
        (Geom.elemcoor(ielem,6)-Geom.elemcoor(ielem,3))^2);
    
Geom.beta(ielem)= atan2((Geom.elemcoor(ielem,6)-Geom.elemcoor(ielem,3))...
            ,(Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,1)));
Geom.gamma(ielem)= atan2((Geom.elemcoor(ielem,5)-Geom.elemcoor(ielem,2))...
            ,(Geom.elemcoor(ielem,4)-Geom.elemcoor(ielem,1)));        
end
end

