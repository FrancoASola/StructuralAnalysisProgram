function [Stiff] = transform_matrices(Geom,Stiff)
%**********************************************************************************************
%   Scriptfile name :   trans3.m    (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       This file calculates the rotation matrix and the element stiffness
%       matrices for each element in a 2D frame.
%
%   Variable descriptions:  (in the order in which they appear)
%
%   ielem            =    counter for the loop
%   nelem            =    number of elements in the structure
%   rotation         =    rotation matrix containing all elements info
%   Rot              =    rotational matrix for 2d-frame element
%   alpha     =    angle between local and global x-axes
%   K                =    element stiffness matrix in global coordinates
%   k                =    element stiffness matrix in local coordinates
%   ktemp            =    temporary element stiffness matrix in local coordinates
%
%**********************************************************************************************

%   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
%   FOR EACH ELEMENT IN THE STRUCTURE
for ielem = 1 : Geom.nelem
    if Geom.istrtp == 3  
    alpha = Geom.alpha(ielem);
    %   SET UP THE ROTATION MATRIX, ROTATION
    Stiff.rotation(1:Stiff.nterm, 1:Stiff.nterm, ielem) = ...
        [
 cos(alpha)  sin(alpha)  0     0          0          0;...
-sin(alpha)  cos(alpha)  0     0          0          0;...
 0           0           1     0          0          0;...
 0           0           0     cos(alpha) sin(alpha) 0;...
 0           0           0    -sin(alpha) cos(alpha) 0;...
 0           0           0     0          0          1];

        
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(Stiff.rotation(r,c,ielem))<=10^-12
            Stiff.rotation(r,c,ielem)=0;
        end
      end
    end
    
elseif Geom.istrtp == 4  
     alpha = Geom.alpha(ielem);
    %   SET UP THE ROTATION MATRIX, ROTATION
    zerom=zeros(3,3);
    Ralpha=[cos(alpha) 0 sin(alpha); 0 1 0; -sin(alpha) 0 cos(alpha)];
    Stiff.rotation(1:Stiff.nterm, 1:Stiff.nterm, ielem) = ...
        [Ralpha zerom;zerom Ralpha];
    
     for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(Stiff.rotation(r,c,ielem))<=10^-12
            Stiff.rotation(r,c,ielem)=0;
        end
      end
    end
elseif Geom.istrtp == 6
   beta = Geom.beta(ielem);
   gamma= Geom.gamma(ielem);
   elemalpha=Geom.elemalpha(ielem);
   zerom=zeros(3,3);
   Rbeta=[cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
   Rgamma=[cos(gamma) sin(gamma) 0 ;-sin(gamma) cos(gamma)  0 ;0 0 1];
   Ralpha=[1 0 0; 0 cos(elemalpha) sin(elemalpha); 0  -sin(elemalpha) cos(elemalpha)];
   elemtrans=Ralpha*Rgamma*Rbeta;
  Stiff.rotation(1:Stiff.nterm, 1:Stiff.nterm, ielem) = ... 
   [elemtrans, zerom, zerom, zerom;...
    zerom,elemtrans, zerom, zerom;...
    zerom, zerom, elemtrans,zerom;...
    zerom, zerom, zerom, elemtrans];
         for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(Stiff.rotation(r,c,ielem))<=10^-12
            Stiff.rotation(r,c,ielem)=0;
        end
      end
    end
    end

%
    Rot  =  Stiff.rotation(1:Stiff.nterm, 1:Stiff.nterm, ielem); 
    ktemp = Stiff.k(1:Stiff.nterm, 1:Stiff.nterm, ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Ke(1:Stiff.nterm, 1:Stiff.nterm, ielem) = Rot'*ktemp*Rot;
    
    Stiff.Kg(1:Stiff.nterm, 1:Stiff.nterm, ielem) = 0;
end
end


