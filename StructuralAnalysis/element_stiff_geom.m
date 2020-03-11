<<<<<<< HEAD
%function[Kg,normold,norm] = element_stiff_geom(npoin,nelem,ndofpn,nodecoor,LM_n,Rot,Delta,nterm,lnods,Plocal,normold)
    function[Geom,Stiff,norm] = element_stiff_geom(Geom,Force,Stiff);
%**********************************************************************************************
%   Scriptfile name:    stifflg3.m   (for 2d-frame structures)
%
%   Main program:       casap.m
%
%       When this file is called, it computes the geometry element stiffness matrix
%       of a 2-D frame element in local coordinates.  The geometry element stiffness
%       matrix is calculated for each element in the structure.
%
%   Variable descriptions:  (in the order in which the appear)
%
%       ielem            =   counter for loop
%       nelem            =   number of element in the structure
%       kg(6,6,ielem)    =   element geometric stiffness matrix in local coordinates
%       plocal(:,ielem)  =   internal force in each elememt
%       L(ielem)         =   lenght of element ielem
%       newLM_n          =   LM vector for geometric nonlinearity
%       New_nodecoor     =   node coordinate for geometric nonlinearity
%       elemcoor_new     =   element coordinate for geometric nonlinearity
%       Lg               =   length for geometric nonlinearity
%       alpha_new        =   angle for geometric nonlinearity
%**********************************************************************************************
Stiff.normnew = max(abs(Stiff.Delta));
Stiff.norm = abs((Stiff.normnew - Stiff.normold) / Stiff.normnew);
Stiff.normold = Stiff.normnew;
%---------------------------------------------
% nodecoor_new update
%---------------------------------------------

if Geom.istrtp == 3  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , Stiff.ndofpn - 1);
for i = 1 : Geom.npoin
    for j = 1 : Stiff.ndofpn-1
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,3) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,4) - elemcoor_new(ielem,2))^2);
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,4) - elemcoor_new(ielem,2)) , (elemcoor_new(ielem,3) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[0, 0, 0, 0, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        0, 0, 0, 0, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [cos(alpha_new(ielem)),sin(alpha_new(ielem)),0,0,0,0;
        -sin(alpha_new(ielem)), cos(alpha_new(ielem)), 0,0,0,0;
        0,0,1,0,0,0 ;
        0,0,0,cos(alpha_new(ielem)),sin(alpha_new(ielem)),0;
        0,0,0,-sin(alpha_new(ielem)),cos(alpha_new(ielem)), 0;
        0,0,0,0,0,1];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end

if Geom.istrtp == 4  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , 3);
for i = 1 : Geom.npoin
    for j = 1 : 3
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,4) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,6) - elemcoor_new(ielem,3))^2);
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,6) - elemcoor_new(ielem,3)) , (elemcoor_new(ielem,4) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[1, 0, 0, -1, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        -1, 0, 0, 1, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
     zerom=zeros(3,3);
    Ralpha=[cos(alpha_new(ielem)) 0 sin(alpha_new(ielem)); 0 1 0; -sin(alpha_new(ielem)) 0 cos(alpha_new(ielem))];
     rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem)=[Ralpha zerom;zerom Ralpha];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end
if Geom.istrtp == 6
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , 3);
for i = 1 : Geom.npoin
    for j = 1 : 3
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,4) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,5) - elemcoor_new(ielem,2))^2+ (elemcoor_new(ielem,6) - elemcoor_new(ielem,3))^2);
    beta_new(ielem)= atan2((elemcoor_new(ielem,6)-elemcoor_new(ielem,3))...
            ,(elemcoor_new(ielem,4)-elemcoor_new(ielem,1)));
    gamma_new(ielem)= atan2((elemcoor_new(ielem,5)-elemcoor_new(ielem,2))...
            ,(elemcoor_new(ielem,4)-elemcoor_new(ielem,1))); 
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = (Force.Plocal_n(ielem)/L)*[0 0 0 0 0 0 0 0 0 0 0 0;...
      0 6/5 0 0 0 L/10 0 -6/5 0 0 0 L/10;...
      0 0 6/5 0 -L/10 0 0 0 -6/5 0 -L/10 0;...
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 0 -L/10 0 (2*L^2)/15 0 0 0 L/10 0 (-L^2)/30 0;...
      0 L/10 0 0 0 (2*L^2)/15 0 -L/10 0 0 0 (-L^2)/30    ;... 
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 -6/5 0 0 0 -L/10 0 6/5 0 0 0 -L/10;...
      0 0 -6/5 0 L/10 0 0 0 6/5 0 L/10 0 ;...
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 0 -L/10 0 (-L^2)/30 0 0 0 L/10 0 (2*L^2)/15 0;... 
      0 L/10 0 0 0 (-L^2)/30 0 -L/10 0 0 0 (2*L^2)/15];...  

end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    Rbeta_new=[cos(beta_new(ielem)) 0 sin(beta_new(ielem)); 0 1 0; -sin(beta_new(ielem)) 0 cos(beta_new(ielem))];
    Rgamma_new=[cos(gamma_new(ielem)) sin(gamma_new(ielem)) 0 ;-sin(gamma_new(ielem)) cos(gamma_new(ielem))  0 ;0 0 1];
%     Ralpha=[1 0 0; 0 cos(Geom.elemalpha) sin(Geom.elemalpha); 0  -sin(Geom.elemalpha) cos(elemalpha)];
   elemtrans=Rgamma_new*Rbeta_new;
    zerom=zeros(3,3);
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [elemtrans, zerom, zerom, zerom;...
    zerom,elemtrans, zerom, zerom;...
    zerom, zerom, elemtrans,zerom;...
    zerom, zerom, zerom, elemtrans];
        
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end

%% Perform Buckling Analysis
if Geom.Stability==1 
  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , Stiff.ndofpn - 1);
for i = 1 : Geom.npoin
    for j = 1 : Stiff.ndofpn-1
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,4) - elemcoor_new(ielem,2)) , (elemcoor_new(ielem,3) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Geom.L(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[0, 0, 0, 0, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        0, 0, 0, 0, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [cos(alpha_new(ielem)),sin(alpha_new(ielem)),0,0,0,0;
        -sin(alpha_new(ielem)), cos(alpha_new(ielem)), 0,0,0,0;
        0,0,1,0,0,0 ;
        0,0,0,cos(alpha_new(ielem)),sin(alpha_new(ielem)),0;
        0,0,0,-sin(alpha_new(ielem)),cos(alpha_new(ielem)), 0;
        0,0,0,0,0,1];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end


aug_total_dofs      =  Stiff.ndofpn * Geom.npoin;
LM                  = abs(Geom.LM);
Ke_aug  =  zeros(aug_total_dofs);
Kg_aug  =  zeros(aug_total_dofs);
for ielem = 1 : Geom.nelem
    for r = 1 : Stiff.nterm
        lr = LM(ielem,r);
        for c = 1 : Stiff.nterm
            lc = LM(ielem,c);
            Kg_aug(lr,lc) = Kg_aug(lr,lc)+Stiff.Kg(r,c,ielem);
        end
    end
end

Ke_aug  =  zeros(aug_total_dofs);
for ielem = 1 : Geom.nelem
    for r = 1 : Stiff.nterm
        lr = LM(ielem,r);
        for c = 1 : Stiff.nterm
            lc = LM(ielem,c);
            Ke_aug(lr,lc) = Ke_aug(lr,lc)+Stiff.Ke(r,c,ielem);
        end
    end
end
[phi,mu]=eig(inv(Ke_aug(1:Stiff.number_gdofs,1:Stiff.number_gdofs))*Kg_aug(1:Stiff.number_gdofs,1:Stiff.number_gdofs));
lam=-1./mu;
lam=min(min(abs(lam)))
Stiff.Ke_aug=Ke_aug;
Stiff.Kg_aug=Kg_aug;
end

end

=======
%function[Kg,normold,norm] = element_stiff_geom(npoin,nelem,ndofpn,nodecoor,LM_n,Rot,Delta,nterm,lnods,Plocal,normold)
    function[Geom,Stiff,norm] = element_stiff_geom(Geom,Force,Stiff);
%**********************************************************************************************
%   Scriptfile name:    stifflg3.m   (for 2d-frame structures)
%
%   Main program:       casap.m
%
%       When this file is called, it computes the geometry element stiffness matrix
%       of a 2-D frame element in local coordinates.  The geometry element stiffness
%       matrix is calculated for each element in the structure.
%
%   Variable descriptions:  (in the order in which the appear)
%
%       ielem            =   counter for loop
%       nelem            =   number of element in the structure
%       kg(6,6,ielem)    =   element geometric stiffness matrix in local coordinates
%       plocal(:,ielem)  =   internal force in each elememt
%       L(ielem)         =   lenght of element ielem
%       newLM_n          =   LM vector for geometric nonlinearity
%       New_nodecoor     =   node coordinate for geometric nonlinearity
%       elemcoor_new     =   element coordinate for geometric nonlinearity
%       Lg               =   length for geometric nonlinearity
%       alpha_new        =   angle for geometric nonlinearity
%**********************************************************************************************
Stiff.normnew = max(abs(Stiff.Delta));
Stiff.norm = abs((Stiff.normnew - Stiff.normold) / Stiff.normnew);
Stiff.normold = Stiff.normnew;
%---------------------------------------------
% nodecoor_new update
%---------------------------------------------

if Geom.istrtp == 3  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , Stiff.ndofpn - 1);
for i = 1 : Geom.npoin
    for j = 1 : Stiff.ndofpn-1
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,3) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,4) - elemcoor_new(ielem,2))^2);
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,4) - elemcoor_new(ielem,2)) , (elemcoor_new(ielem,3) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[0, 0, 0, 0, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        0, 0, 0, 0, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [cos(alpha_new(ielem)),sin(alpha_new(ielem)),0,0,0,0;
        -sin(alpha_new(ielem)), cos(alpha_new(ielem)), 0,0,0,0;
        0,0,1,0,0,0 ;
        0,0,0,cos(alpha_new(ielem)),sin(alpha_new(ielem)),0;
        0,0,0,-sin(alpha_new(ielem)),cos(alpha_new(ielem)), 0;
        0,0,0,0,0,1];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end

if Geom.istrtp == 4  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , 3);
for i = 1 : Geom.npoin
    for j = 1 : 3
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,4) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,6) - elemcoor_new(ielem,3))^2);
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,6) - elemcoor_new(ielem,3)) , (elemcoor_new(ielem,4) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[1, 0, 0, -1, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        -1, 0, 0, 1, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
     zerom=zeros(3,3);
    Ralpha=[cos(alpha_new(ielem)) 0 sin(alpha_new(ielem)); 0 1 0; -sin(alpha_new(ielem)) 0 cos(alpha_new(ielem))];
     rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem)=[Ralpha zerom;zerom Ralpha];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end
if Geom.istrtp == 6
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , 3);
for i = 1 : Geom.npoin
    for j = 1 : 3
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    Lg(ielem) =  sqrt((elemcoor_new(ielem,4) - elemcoor_new(ielem,1))^2 + (elemcoor_new(ielem,5) - elemcoor_new(ielem,2))^2+ (elemcoor_new(ielem,6) - elemcoor_new(ielem,3))^2);
    beta_new(ielem)= atan2((elemcoor_new(ielem,6)-elemcoor_new(ielem,3))...
            ,(elemcoor_new(ielem,4)-elemcoor_new(ielem,1)));
    gamma_new(ielem)= atan2((elemcoor_new(ielem,5)-elemcoor_new(ielem,2))...
            ,(elemcoor_new(ielem,4)-elemcoor_new(ielem,1))); 
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Lg(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = (Force.Plocal_n(ielem)/L)*[0 0 0 0 0 0 0 0 0 0 0 0;...
      0 6/5 0 0 0 L/10 0 -6/5 0 0 0 L/10;...
      0 0 6/5 0 -L/10 0 0 0 -6/5 0 -L/10 0;...
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 0 -L/10 0 (2*L^2)/15 0 0 0 L/10 0 (-L^2)/30 0;...
      0 L/10 0 0 0 (2*L^2)/15 0 -L/10 0 0 0 (-L^2)/30    ;... 
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 -6/5 0 0 0 -L/10 0 6/5 0 0 0 -L/10;...
      0 0 -6/5 0 L/10 0 0 0 6/5 0 L/10 0 ;...
      0 0 0 0 0 0 0 0 0 0 0 0;...
      0 0 -L/10 0 (-L^2)/30 0 0 0 L/10 0 (2*L^2)/15 0;... 
      0 L/10 0 0 0 (-L^2)/30 0 -L/10 0 0 0 (2*L^2)/15];...  

end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    Rbeta_new=[cos(beta_new(ielem)) 0 sin(beta_new(ielem)); 0 1 0; -sin(beta_new(ielem)) 0 cos(beta_new(ielem))];
    Rgamma_new=[cos(gamma_new(ielem)) sin(gamma_new(ielem)) 0 ;-sin(gamma_new(ielem)) cos(gamma_new(ielem))  0 ;0 0 1];
%     Ralpha=[1 0 0; 0 cos(Geom.elemalpha) sin(Geom.elemalpha); 0  -sin(Geom.elemalpha) cos(elemalpha)];
   elemtrans=Rgamma_new*Rbeta_new;
    zerom=zeros(3,3);
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [elemtrans, zerom, zerom, zerom;...
    zerom,elemtrans, zerom, zerom;...
    zerom, zerom, elemtrans,zerom;...
    zerom, zerom, zerom, elemtrans];
        
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end
end

%% Perform Buckling Analysis
if Geom.Stability==1 
  
for ip = 1:Geom.npoin
    for j = 1:Stiff.ndofpn
        if Geom.LM_n(ip , j) < 0 || j == 3
            newLM_n(ip , j) = 0;
        else if Geom.LM_n(ip , j) > 0
                newLM_n(ip , j) = Stiff.Delta(Geom.LM_n(ip , j));
            end
        end
    end
end
%---------------------------------------------
nodecoor_new = zeros(Geom.npoin , Stiff.ndofpn - 1);
for i = 1 : Geom.npoin
    for j = 1 : Stiff.ndofpn-1
        nodecoor_new(i , j) = newLM_n(i , j);
        Geom.New_nodecoor(i , j) = Geom.nodecoor(i , j) + nodecoor_new(i , j);
    end
end
%---------------------------------------------
% elemcood_new update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    elemcoor_new(ielem , :) = [Geom.New_nodecoor(Geom.lnods(ielem , 1) , :),...
        Geom.New_nodecoor(Geom.lnods(ielem , 2) , :)];
end
%---------------------------------------------
% length update, Lg
%---------------------------------------------
for ielem = 1 : Geom.nelem
    alpha_new(ielem) =  atan2((elemcoor_new(ielem,4) - elemcoor_new(ielem,2)) , (elemcoor_new(ielem,3) - elemcoor_new(ielem,1)));
end
%---------------------------------------------
% kg update
%---------------------------------------------
for ielem = 1 : Geom.nelem
    for itr = 1 :3 : Stiff.nterm
        if Force.Plocal(itr , ielem) <= 0
            Force.Plocal_n(ielem , 1) = Force.Plocal(itr , ielem);
        end
    end
end

for ielem = 1:Geom.nelem
    L=Geom.L(ielem);
    Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Force.Plocal_n(ielem)/L*[0, 0, 0, 0, 0, 0;
        0,6/5, L/10,0,-6/5, L/10;
        0,L/10,2/15*(L)^2, 0,-L/10,-(L)^2/30;
        0, 0, 0, 0, 0, 0;
        0,-6/5,-L/10,0,6/5, -L/10;
        0,L/10,-(L)^2/30,0,-L/10,2/15*(L)^2;];
end
% %---------------------------------------------
% % Transformation kg
% %---------------------------------------------
for ielem = 1:Geom.nelem
    %   SET UP THE ROTATION MATRIX, ROTATION
    rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem) = [cos(alpha_new(ielem)),sin(alpha_new(ielem)),0,0,0,0;
        -sin(alpha_new(ielem)), cos(alpha_new(ielem)), 0,0,0,0;
        0,0,1,0,0,0 ;
        0,0,0,cos(alpha_new(ielem)),sin(alpha_new(ielem)),0;
        0,0,0,-sin(alpha_new(ielem)),cos(alpha_new(ielem)), 0;
        0,0,0,0,0,1];
    for r = 1 : Stiff.nterm
      for c = 1 : Stiff.nterm
        if abs(rotation_n(r,c,ielem))<=10^-12
            rotation_n(r,c,ielem)=0;
        end
      end
    end
    Rot_n  =  rotation_n(1:Stiff.nterm,1:Stiff.nterm,ielem);
    ktemp_n = Stiff.kg(1:Stiff.nterm,1:Stiff.nterm,ielem);
    %   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
    Stiff.Kg(1:Stiff.nterm,1:Stiff.nterm,ielem) = Rot_n' * ktemp_n * Rot_n;
end


aug_total_dofs      =  Stiff.ndofpn * Geom.npoin;
LM                  = abs(Geom.LM);
Ke_aug  =  zeros(aug_total_dofs);
Kg_aug  =  zeros(aug_total_dofs);
for ielem = 1 : Geom.nelem
    for r = 1 : Stiff.nterm
        lr = LM(ielem,r);
        for c = 1 : Stiff.nterm
            lc = LM(ielem,c);
            Kg_aug(lr,lc) = Kg_aug(lr,lc)+Stiff.Kg(r,c,ielem);
        end
    end
end

Ke_aug  =  zeros(aug_total_dofs);
for ielem = 1 : Geom.nelem
    for r = 1 : Stiff.nterm
        lr = LM(ielem,r);
        for c = 1 : Stiff.nterm
            lc = LM(ielem,c);
            Ke_aug(lr,lc) = Ke_aug(lr,lc)+Stiff.Ke(r,c,ielem);
        end
    end
end
[phi,mu]=eig(inv(Ke_aug(1:Stiff.number_gdofs,1:Stiff.number_gdofs))*Kg_aug(1:Stiff.number_gdofs,1:Stiff.number_gdofs));
lam=-1./mu;
lam=min(min(abs(lam)))
Stiff.Ke_aug=Ke_aug;
Stiff.Kg_aug=Kg_aug;
end

end

>>>>>>> f5562fe9cc4b5a6d3e97162c1ad8140984111333
