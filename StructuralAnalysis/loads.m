function[Force] = loads(Geom,Stiff,Force)
% *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  * 
%   Scriptfile name:    loads3.m    (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program:       casap.m
%
%       When this file is called, it computes the fixed end actions for elements which
%       carry distributed loads for a 2-D frame.
%
%   Variable descriptions:  (in the order in which they appear)
%
%       ielem               =   counter for loop
%       nelem               =   number of elements in the structure
%       Pelem(ielem)        =   element point load applied between nodes on element ielem     
%       b(ielem)            =   normalized distance from the left end of the element to the point load
%       L(ielem)            =   length of the element ielem
%       a(ielem)            =   distance from the left end of the element to the point load
%       Fflc                =   fixed end force at the left end due to the point load
%       Mflc                =   fixed end moment at the left end due to the point load
%       Ffrc                =   fixed end force at the right end due to the point load
%       Mfrc                =   fixed end moment at the right end due to the point load
%       w(ielem)            =   distributed load 
%       Ffld                =   fixed end force at the left end due to the distributed load
%       Mfld                =   fixed end moment at the left end due to the distributed load
%       Ffrd                =   fixed end force at the right end due to the distributed load
%       Mfrd                =   fixed end moment at the right end due to the distributed load
%       Ffl                 =   fixed end force at the left end due to the load
%       Mfl                 =   fixed end moment at the left end due to the load
%       Ffr                 =   fixed end force at the right end due to the load
%       Mfr                 =   fixed end moment at the right end due to the load
%       feamatrix_local     =   matrix containing resulting fixed end actions in local coordinates
%       feamatrix_global    =   matrix containing resulting fixed end actions in global coordinates
%       idofpn              =   pointer for the global dofs
%       number_gdofs        =   number of global dofs
%       fea_vector          =   vector of fea's in global dofs, used to calc displacements
%       inode               =   counter for node number   
%       npoin               =   number of nodes in the structure
%       ndofpn              =   number of dof for each node
%       temp1               =   temporary variable
%       temp2               =   temporary variable
%       Load                =   load vector for the unrestrained nodes
%       Pnods               =   array of nodal loads in global dof
%
% *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  * 
nelem = Geom.nelem;
rotation = Stiff.rotation;

L = Geom.L;


%% 
%   CALCULATE THE FIXED END ACTIONS AND INSERT INTO A MATRIX IN WHICH THE ROWS CORRESPOND
%   WITH THE ELEMENT NUMBER AND THE COLUMNS CORRESPOND WITH THE ELEMENT LOCAL DEGREES
%   OF FREEDOM

for ielem=1:nelem
    % FOR CONCENTRATED LOADS 
   if Geom.istrtp == 3  %% 2D Frame
       a = Force.a;
       Pelem = Force.Pelem;
       w = Force.w;
    if Pelem(ielem) ~= 0
        %b = a(ielem) / L(ielem);
        Fflc = (Pelem(ielem)/L(ielem)^3)*(L(ielem)-a(ielem))^2*(L(ielem)+2*a(ielem));
        Ffrc = (Pelem(ielem)*a(ielem)^2/L(ielem)^3)*(3*L(ielem)-2*a(ielem));
        Mflc = ((Pelem(ielem)*a(ielem))/L(ielem)^2)*(L(ielem)-a(ielem))^2;
        Mfrc = ((-Pelem(ielem)*a(ielem)^2)*(L(ielem)-a(ielem)))/L(ielem)^2;
    else 
        Fflc = 0;
        Ffrc = 0;
        Mflc = 0;
        Mfrc = 0;  
    end
    % FOR UNIFORMLY DISTRIBUTED LOADS
    if  w(ielem) ~= 0
        Ffld = -w(ielem)*L(ielem)/2;
        Ffrd = -w(ielem)*L(ielem)/2;
        Mfld = -w(ielem)*L(ielem)^2/12;
        Mfrd = w(ielem)*L(ielem)^2/12;
    else 
        Ffld = 0;
        Ffrd = 0;
        Mfld = 0;
        Mfrd = 0;  
    end
    Ffl = Fflc+Ffld;
    Ffr = Ffrc+Ffrd;
    Mfl = Mflc+Mfld;
    Mfr = Mfrc+Mfrd;
    % GLOBAL FEA MATRIX 
    Force.feamatrix_local(ielem,:)=[0; Ffl; Mfl; 0; Ffr; Mfr];
    %   ROTATE THE LOCAL FEA MATRIX TO GLOBAL
    Force.feamatrix_global(ielem,:) = (rotation(:,:,ielem)' * Force.feamatrix_local(ielem,:)')';
    
   elseif Geom.istrtp == 4 %%Grid
       a = Force.a;
       Pelem = Force.Pelem;
       w = Force.w;
       if Pelem(ielem) ~= 0
        %b = a(ielem) / L(ielem);
        Fflc = (Pelem(ielem)/L(ielem)^3)*(L(ielem)-a(ielem))^2*(L(ielem)+2*a(ielem));
        Ffrc = (Pelem(ielem)*a(ielem)^2/L(ielem)^3)*(3*L(ielem)-2*a(ielem));
        Mflc = ((Pelem(ielem)*a(ielem))/L(ielem)^2)*(L(ielem)-a(ielem))^2;
        Mfrc = ((-Pelem(ielem)*a(ielem)^2)*(L(ielem)-a(ielem)))/L(ielem)^2;
    else 
        Fflc = 0;
        Ffrc = 0;
        Mflc = 0;
        Mfrc = 0;  
    end
    % FOR UNIFORMLY DISTRIBUTED LOADS
    if  w(ielem) ~= 0
        Ffld = w(ielem)*L(ielem)/2;
        Ffrd = w(ielem)*L(ielem)/2;
        Mfld = w(ielem)*L(ielem)^2/12;
        Mfrd = -w(ielem)*L(ielem)^2/12;
    else 
        Ffld = 0;
        Ffrd = 0;
        Mfld = 0;
        Mfrd = 0;  
    end
    Ffl = Fflc+Ffld;
    Ffr = Ffrc+Ffrd;
    Mfl = Mflc+Mfld;
    Mfr = Mfrc+Mfrd;
    % GLOBAL FEA MATRIX 
    Force.feamatrix_local(ielem,:)=[0; Ffl; Mfl; 0; Ffr; Mfr];
    %   ROTATE THE LOCAL FEA MATRIX TO GLOBAL
    Force.feamatrix_global(ielem,:) = (rotation(:,:,ielem)' * Force.feamatrix_local(ielem,:)')';
    
   elseif Geom.istrtp == 6 %%3D Frame
       Pelemx = Force.Pelemx;
       Pelemy = Force.Pelemy;
       Pelemz = Force.Pelemz;
       wx = Force.wx;
       wy = Force.wy;
       wz = Force.wz;
       ax = Force.ax;
       ay = Force.ay;
       az = Force.az;
       if Pelemx(ielem) ~= 0
        %b = a(ielem) / L(ielem);
        Fflcx = (Pelemx(ielem)/L(ielem)^3)*(L(ielem)-ax(ielem))^2*(L(ielem)+2*ax(ielem));
        Ffrcx = (Pelemx(ielem)*ax(ielem)^2/L(ielem)^3)*(3*L(ielem)-2*ax(ielem));
        Mflcx = ((Pelemx(ielem)*ax(ielem))/L(ielem)^2)*(L(ielem)-ax(ielem))^2;
        Mfrcx = ((-Pelemx(ielem)*ax(ielem)^2)*(L(ielem)-ax(ielem)))/L(ielem)^2;
    else 
        Fflcx = 0;
        Ffrcx = 0;
        Mflcx = 0;
        Mfrcx = 0;  
    end
    % FOR UNIFORMLX DISTRIBUTED LOADS
    if  wx(ielem) ~= 0
        Ffldx = wx(ielem)*L(ielem)/2;
        Ffrdx = wx(ielem)*L(ielem)/2;
        Mfldx = wx(ielem)*L(ielem)^2/12;
        Mfrdx = -wx(ielem)*L(ielem)^2/12;
    else 
        Ffldx = 0;
        Ffrdx = 0;
        Mfldx = 0;
        Mfrdx = 0;  
    end
    Fflx = Fflcx+Ffldx;
    Ffrx = Ffrcx+Ffrdx;
    Mflx = Mflcx+Mfldx;
    Mfrx = Mfrcx+Mfrdx;

       if Pelemy(ielem) ~= 0
        %b = a(ielem) / L(ielem);
        Fflcy = (Pelemy(ielem)/L(ielem)^3)*(L(ielem)-ay(ielem))^2*(L(ielem)+2*ay(ielem));
        Ffrcy = (Pelemy(ielem)*ay(ielem)^2/L(ielem)^3)*(3*L(ielem)-2*ay(ielem));
        Mflcy = ((Pelemy(ielem)*ay(ielem))/L(ielem)^2)*(L(ielem)-ay(ielem))^2;
        Mfrcy = ((-Pelemy(ielem)*ay(ielem)^2)*(L(ielem)-ay(ielem)))/L(ielem)^2;
    else 
        Fflcy = 0;
        Ffrcy = 0;
        Mflcy = 0;
        Mfrcy = 0;  
    end
    % FOR UNIFORMLY DISTRIBUTED LOADS
    if  wy(ielem) ~= 0
        Ffldy = wy(ielem)*L(ielem)/2;
        Ffrdy = wy(ielem)*L(ielem)/2;
        Mfldy = wy(ielem)*L(ielem)^2/12;
        Mfrdy = -wy(ielem)*L(ielem)^2/12;
    else 
        Ffldy = 0;
        Ffrdy = 0;
        Mfldy = 0;
        Mfrdy = 0;  
    end
    Ffly = Fflcy+Ffldy;
    Ffry = Ffrcy+Ffrdy;
    Mfly = Mflcy+Mfldy;
    Mfry = Mfrcy+Mfrdy;
    if Pelemz(ielem) ~= 0
        %b = a(ielem) / L(ielem);
        Fflcz = (Pelemz(ielem)/L(ielem)^3)*(L(ielem)-az(ielem))^2*(L(ielem)+2*az(ielem));
        Ffrcz = (Pelemz(ielem)*az(ielem)^2/L(ielem)^3)*(3*L(ielem)-2*az(ielem));
        Mflcz = ((Pelemz(ielem)*az(ielem))/L(ielem)^2)*(L(ielem)-az(ielem))^2;
        Mfrcz = ((-Pelemz(ielem)*az(ielem)^2)*(L(ielem)-az(ielem)))/L(ielem)^2;
    else 
        Fflcz = 0;
        Ffrcz = 0;
        Mflcz = 0;
        Mfrcz = 0;  
    end
    % FOR UNIFORMLY DISTRIBUTED LOADS ALONG Z
    if  wz(ielem) ~= 0
        Ffldz = wz(ielem)*L(ielem)/2;
        Ffrdz = wz(ielem)*L(ielem)/2;
        Mfldz = wz(ielem)*L(ielem)^2/12;
        Mfrdz = -wz(ielem)*L(ielem)^2/12;
    else 
        Ffldz = 0;
        Ffrdz = 0;
        Mfldz = 0;
        Mfrdz = 0;  
    end
    Fflz = Fflcz+Ffldz;
    Ffrz = Ffrcz+Ffrdz;
    Mflz = Mflcz+Mfldz;
    Mfrz = Mfrcz+Mfrdz;

    % GLOBAL FEA MATRIX 
    Force.feamatrix_local(ielem,:)=[Fflx; Ffly; Fflz; Mflx; Mflz; Mfly; Ffrx; Ffry; Ffrz; Mfrx; Mfrz; Mfry];
    %   ROTATE THE LOCAL FEA MATRIX TO GLOBAL
    Force.feamatrix_global(ielem,:) = (rotation(:,:,ielem)' * Force.feamatrix_local(ielem,:)')';
    
end
end
%   CREATE A LOAD VECTOR 
%   INITIALIZE FEA VECTOR TO ALL ZEROS  
for idofpn = 1 : Stiff.number_gdofs
    fea_vector(idofpn,1) = 0;
end
%   CREATE A LOAD VECTOR USING THE LM MATRIX
for inode = 1 : Geom.npoin
    for i = 1 : Stiff.ndofpn
        if Stiff.number_gdofs > 0
            for idofpn=1 : Stiff.number_gdofs
                temp1 = Force.feamatrix_global(find(Geom.LM==idofpn));
                temp2 = sum(temp1);
                fea_vector(idofpn,1) = temp2;
            end
            %   ASSEMBLE THE LOAD VECTOR 
            Load = Force.Pnods  +  fea_vector;
        end
    end
end
%% 
Force.Load=Load;
end

