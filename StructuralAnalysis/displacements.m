function[Stiff]=displacements(fid,Geom,Stiff,Force)
%**********************************************************************************************
%   Scriptfile name :   disp3.m (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       When this file is called, it computes the displacements in the global
%       degrees of freedom.
%
%   Variable descriptions:  (in the order in which they appear)
%
%       Ksinv       =   inverse of the structural stiffness matrix
%       Ktt     =   structural stiffness matrix
%       Delta       =   vector of displacements for the global degrees of freedom
%       Pnods       =   vector of nodal loads in the global degrees of freedom
%
%       Simplified for 2D Frame Case only
%
%**********************************************************************************************

%   CREATE A TEMPORARY VARIABLE EQUAL TO THE INVERSE OF THE STRUCTURAL STIFFNESS MATRIX
%   DISPLACEMENTS CAN BE COMPUTED ONLY IF THERE ARE UNRESTRAINED NODES
if Geom.istrtp == 3
    if Stiff.number_gdofs > 0
    Ksinv = inv(Stiff.Ktt);
    %   CALCULATE THE DISPLACEMENTS IN GLOBAL COORDINATES
    Stiff.Delta = Ksinv*Force.Load;
    %   PRINT DISPLACEMENTS WITH NODE INFO
    fprintf(fid,'   Displacements:\n');
    for k=1 : size(Stiff.Delta,1)
        LM_spot = find(Geom.LM' == k);
        elem = fix(LM_spot(1) / (Stiff.nterm+1))+1;
        dof = mod(LM_spot(1)-1 , Stiff.nterm)+1;
        node = Geom.lnods(elem , fix(dof/4)+1);
        switch(dof);
            case {1,4},  dof = 'delta X';
            case {2,5},  dof = 'delta Y';
            otherwise,   dof = 'rotate ';
        end
        %PRINT THE DISPLACEMENTS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Stiff.Delta(k));
    end
    fprintf(fid,'\n');
    end
end
if Geom.istrtp == 4
    if Stiff.number_gdofs > 0
    Ksinv = inv(Stiff.Ktt);
    %   CALCULATE THE DISPLACEMENTS IN GLOBAL COORDINATES
    Stiff.Delta = Ksinv*Force.Load;
    %   PRINT DISPLACEMENTS WITH NODE INFO
    fprintf(fid,'   Displacements:\n');
    for k=1 : size(Stiff.Delta,1)
        LM_spot = find(Geom.LM' == k);
        elem = fix(LM_spot(1) / (Stiff.nterm+1))+1;
        dof = mod(LM_spot(1)-1 , Stiff.nterm)+1;
        node = Geom.lnods(elem , fix(dof/4)+1);
        switch(dof);
            case {1,4},  dof = 'rotate X';
            case {2,5},  dof = 'delta Y';
            otherwise,   dof = 'rotate Z';
        end
        %PRINT THE DISPLACEMENTS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Stiff.Delta(k));
    end
    fprintf(fid,'\n');
    end
end
if Geom.istrtp == 6
    if Stiff.number_gdofs > 0
    Ksinv = inv(Stiff.Ktt);
    %   CALCULATE THE DISPLACEMENTS IN GLOBAL COORDINATES
    Stiff.Delta = Ksinv*Force.Load;
    %   PRINT DISPLACEMENTS WITH NODE INFO
    fprintf(fid,'   Displacements:\n');
    for k=1 : size(Stiff.Delta,1)
        LM_spot = find(Geom.LM' == k);
        elem = fix(LM_spot(1) / (Stiff.nterm+1))+1;
        dof = mod(LM_spot(1)-1 , Stiff.nterm)+1;
        node = Geom.lnods(elem , fix(dof/7)+1);
        switch(dof);
            case {1,7},  dof = 'delta X';
            case {2,8},  dof = 'delta Y';
            case {3,9},  dof = 'delta Z';
            case {4,10}, dof = 'rotate x';
            case {5,11}, dof = 'rotate y';
            otherwise,   dof = 'rotate z';
        end
        %PRINT THE DISPLACEMENTS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Stiff.Delta(k));
    end
    fprintf(fid,'\n');
    end
end
end
