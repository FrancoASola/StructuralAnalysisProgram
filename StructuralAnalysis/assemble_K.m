function [Stiff] =  assemble_K(Geom,Stiff)
%**********************************************************************************************
%   Scriptfile name :   assembl.m  (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       This file assembles the global structural stiffness matrix from the
%       element stiffness matrices in global coordinates using the LM vectors.
%       In addition, this file assembles the augmented stiffness matrix.
%
%   Variable Descriptions (in order of appearance):
%
%       LM(a,b)          =    LM matrix
%       new_LM           =    LM matrix used in assembling the augmented stiffness matrix
%       number_gdofs     =    Number of global dofs
%       aug_total_dofs   =    Total number of structure dofs
%       Ksize            =    Size of element stiffness matrix in global coordinates
%       K_aug            =    Augmented structural stiffness matrix
%       ielem            =    Counter for element number
%       nelem            =    Number of elements in the structure
%       r                =    Row position in the element stiffness matrix
%       lr               =    Row position in the augmeneted stiffness matrix
%       c                =    Column position in the element stiffness matrix
%       lc               =    Column position in the augmeneted stiffness matrix
%       Ke               =    Elastic Structural Stiffness Matrix 
%       Kg               =    Geometric Structural Stiffness Matrix 
%       Ktt              =    Structural Stiffness Matrix (Upper left part of AK_aug)
%       Ktu              =    Upper right part of Augmented structural stiffness matrix
%       Kut              =    Lower left part of Augmented structural stiffness matrix
%       Kuu              =    Lower rigth part of Augmented structural stiffness matrix
%
%**********************************************************************************************
%  RENUMBER DOF INCLUDE ALL DOF, FREE DOF FIRST, RESTRAINED NEXT
LM                  = abs(Geom.LM);
Stiff.number_gdofs =  max(Geom.LM(:));
aug_total_dofs      =  Stiff.ndofpn * Geom.npoin;
Ksize               =  (2 * Stiff.ndofpn)^2;

%   ASSEMBLE THE AUGMENTED STRUCTURAL STIFFNESS MATRIX
K_aug  =  zeros(aug_total_dofs);

for ielem = 1 : Geom.nelem
    for r = 1 : Stiff.nterm
        lr = LM(ielem,r);
        for c = 1 : Stiff.nterm
            lc = LM(ielem,c);
            if Geom.GNL==1
            K_aug(lr,lc) = K_aug(lr,lc)+Stiff.Ke(r,c,ielem)+Stiff.Kg(r,c,ielem);
            else 
            K_aug(lr,lc) = K_aug(lr,lc)+Stiff.Ke(r,c,ielem);
            end
        end
    end
end

%   SET UP SUBMATRICES FROM THE AUGMENTED STIFFNESS MATRIX

if Stiff.number_gdofs > 0  
    Stiff.Ktt  =  K_aug(1:Stiff.number_gdofs,1:Stiff.number_gdofs);
    Stiff.Ktu  =  K_aug(1:Stiff.number_gdofs,Stiff.number_gdofs+1:aug_total_dofs);
    Stiff.Kut  =  K_aug(Stiff.number_gdofs+1:aug_total_dofs,1:Stiff.number_gdofs);
    Stiff.Kuu  =  K_aug(Stiff.number_gdofs+1:aug_total_dofs,1:Stiff.number_gdofs);
else
%   IF ALL THE DEGREE OF FREEDOM ARE CONSTRAINED    
    Stiff.Kuu = Stiff.K_aug; 
end
    Stiff.K_aug=K_aug;
end
