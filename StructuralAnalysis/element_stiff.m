function [Stiff] = element_stiff(Geom,Prop,Stiff)
%**********************************************************************************************
%   Scriptfile name:    stiffl3.m   (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program:       casap.m
%
%       When this file is called, it computes the element stiffness matrix
%       of a 2-D frame element in local coordinates.  The element stiffness
%       matrix is calculated for each element in the structure.
%
%       The matrices are stored in a single matrix of dimensions 6x6*i and
%       can be recalled individually later in the program.
%
%   Variable descriptions:  (in the order in which the appear)
%
%       ielem        =    counter for loop
%       nelem        =    number of element in the structure
%       k(6,6,ielem) =    element stiffness matrix in local coordinates
%       E     =    modulus of elasticity of element ielem
%       A     =    cross-sectional area of element ielem
%       L     =    lenght of element ielem
%       Iz    =    moment of inertia with respect to the local z-axis of element ielem
%
%**********************************************************************************************

for ielem = 1:Geom.nelem
    L = Geom.L(ielem);
    A = Prop.A(ielem);
    Iz = Prop.Iz(ielem);
    E = Prop.E(ielem);
    EA=E*A;
    EIz=E*Iz;
   
if Geom.istrtp == 3     
    Stiff.k(1:Stiff.nterm,1:Stiff.nterm,ielem) = ...
      [ EA/L , 0 , 0, -EA/L , 0 , 0 ;...
        0, 12*EIz/L^3, 6*EIz/L^2, 0, -12*EIz/L^3, 6*EIz/L^2 ;...
        0, 6*EIz/L^2, 4*EIz/L, 0, -6*EIz/L^2, 2*EIz/L;...
       -EA/L , 0 , 0 EA/L , 0 , 0;...
        0, -12*EIz/L^3, -6*EIz/L^2, 0, 12*EIz/L^3, -6*EIz/L^2 ;...
        0, 6*EIz/L^2, 2*EIz/L, 0, -6*EIz/L^2, 4*EIz/L];

elseif Geom.istrtp == 4
    G=Prop.G(ielem);
    GIx=G*Prop.Ix(ielem);
    Stiff.k(1:Stiff.nterm,1:Stiff.nterm,ielem) = ...
      [ GIx/L, 0 , 0, -GIx/L , 0 , 0 ;...
        0, 12*EIz/L^3, 6*EIz/L^2, 0, -12*EIz/L^3, 6*EIz/L^2 ;...
        0, 6*EIz/L^2, 4*EIz/L, 0, -6*EIz/L^2, 2*EIz/L;...
       -GIx/L , 0 , 0 GIx/L , 0 , 0;...
        0, -12*EIz/L^3, -6*EIz/L^2, 0, 12*EIz/L^3, -6*EIz/L^2 ;...
        0, 6*EIz/L^2, 2*EIz/L, 0, -6*EIz/L^2, 4*EIz/L];

elseif Geom.istrtp == 6
    EIy=E*Prop.Iy(ielem);
    G=Prop.G(ielem);
    GIx=G*Prop.Ix(ielem);
     Stiff.k(1:Stiff.nterm,1:Stiff.nterm,ielem) = ...
     [EA/L 0 0 0 0 0 -EA/L 0 0 0 0 0;
      0 12*EIz/(L^3) 0 0 0 6*EIz/(L^2) 0 -12*EIz/(L^3) 0 0 0 6*EIz/(L^2);...
      0 0 12*EIy/(L^3) 0 -6*EIy/(L^2) 0 0 0 -12*EIy/(L^3) 0 -6*EIy/(L^2) 0;...
      0 0 0 GIx/L 0 0 0 0 0 -GIx/L 0 0;...
      0 0 -6*EIy/(L^2) 0 4*EIy/L 0 0 0 6*EIy/(L^2) 0 2*EIy/L 0;...
      0 6*EIz/(L^2) 0 0 0 4*EIz/L 0 -6*EIz/(L^2) 0 0 0 2*EIz/L;... 
      -EA/L 0 0 0 0 0 EA/L 0 0 0 0 0;...
      0 -12*EIz/(L^3) 0 0 0 -6*EIz/(L^2) 0 12*EIz/(L^3) 0 0 0 -6*EIz/(L^2);...
      0 0 -12*EIy/(L^3) 0 6*EIy/(L^2) 0 0 0 12*EIy/(L^3) 0 6*EIy/(L^2) 0 ;...
      0 0 0 -GIx/L 0 0 0 0 0 GIx/L 0 0;...
      0 0 -6*EIy/(L^2) 0 2*EIy/L 0 0 0 6*EIy/(L^2) 0 4*EIy/L 0;... 
      0 6*EIz/(L^2) 0 0 0 2*EIz/L 0 -6*EIz/(L^2) 0 0 0 4*EIz/L ];...  
end
end
end

