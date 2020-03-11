function print_forces(fid,Geom,Force,Stiff)
%**********************************************************************************************
%   Scriptfile name  :    print_loads.m
%
%   Main program     :    casap.m
%
%       Prints the current load case data to the output file w.r.t 
%       the type of structure under analysis
%       1   =   BEAM
%       2   =   2DTRUSS
%       3   =   2DFRAME
%       4   =   GRID
%       5   =   3DTRUSS
%       6   =   3DFRAME
%
%**********************************************************************************************
%% Retrieve some data
iter = Stiff.iter;
istrtp = Geom.istrtp;
nelem = Geom.nelem;
lnods = Geom.lnods;
LM = Geom.LM;
nterm = Stiff.nterm;
iload = Force.iload;
Pnods = Force.Pnods;



%%
if iter == 1
Load_case = iload;
if iload == 1
    fprintf(fid,'\n_________________________________________________________________________\n\n');
end

%   CASE 1 :   BEAM STRUCTURE
if istrtp == 1
    a = Force.a;
    Pelem = Force.Pelem;
    w = Force.w;
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM'==k);
        elem    = fix(LM_spot(1)/(nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1,nterm) + 1;
        node    = lnods(elem,fix(dof/3) + 1);   
        switch(dof)
            case {1,3}, dof = 'Fy';
            otherwise,  dof = ' M';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    %   PRINT ELEMENT LOADS OR LOADS WHICH ARE APPLIED BETWEEN NODES
    fprintf(fid,'\n   Elemental Loads : \n');
    for k=1 : nelem
        fprintf(fid,'     Element :  %d   Point load = %d at %d from left\n',k,Pelem(k),a(k));
        fprintf(fid,'                  Distributed load = %d\n',w(k));
    end
    fprintf(fid,'\n');
    
%   CASE 2 :   2DTRUSS STRUCTURE
elseif istrtp == 2
    a = Force.a;
    Pelem = Force.Pelem;
    
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM'==k);
        elem    = fix(LM_spot(1)/(nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1,nterm) + 1;
        node    = lnods(elem,fix(dof/3) + 1);
        switch(dof)
            case {1,3}, dof = 'Fx';
            otherwise,  dof = 'Fy';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    fprintf(fid,'\n');
    
%   CASE 3 :   2DFRAME STRUCTURE
elseif istrtp == 3
    a = Force.a;
    Pelem = Force.Pelem;
    w = Force.w;
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM' == k);
        elem    = fix(LM_spot(1)/(nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1,nterm) + 1;
        node    = lnods(elem,fix(dof/4) + 1);
        switch(dof)
            case {1,4}, dof = 'Fx';
            case {2,5}, dof = 'Fy';
            otherwise,  dof = ' M';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    %   PRINT ELEMENT LOADS OR LOADS WHICH ARE APPLIED BETWEEN NODES
    fprintf(fid,'\n   Elemental Loads : \n');
    for k=1 : nelem
        fprintf(fid,'     Element :  %d   Point load = %d at %d from left\n',k,Pelem(k),a(k));
        fprintf(fid,'                  Distributed load = %d\n',w(k));
    end
    fprintf(fid,'\n');
    
%   CASE 4 :   GRID STRUCTURE
elseif istrtp == 4
    a = Force.a;
    Pelem = Force.Pelem;
    w = Force.w;
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM' == k);
        elem    = fix(LM_spot(1) / (nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1, nterm) + 1;
        node    = lnods(elem,fix(dof/4) + 1);
        switch(dof)
            case {1,4}, dof = 'Tx';
            case {2,5}, dof = 'Fy';
            otherwise,  dof = 'Mz';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    %   PRINT ELEMENT LOADS OR LOADS WHICH ARE APPLIED BETWEEN NODES
    fprintf(fid,'\n   Elemental Loads : \n');
    for k=1 : nelem
        fprintf(fid,'     Element :  %d   Point load = %d at %d from left\n',k,Pelem(k),a(k));
        fprintf(fid,'                  Distributed load = %d\n',w(k));
    end
    fprintf(fid,'\n');
    
%   CASE 5 :   3DTRUSS STRUCTURE
elseif istrtp == 5
    a = Force.a;
    Pelem = Force.Pelem;
    
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM' == k);
        elem    = fix(LM_spot(1) / (nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1, nterm) + 1;
        node    = lnods(elem,fix(dof/4) + 1);
        switch(dof)
            case {1,4}, dof = 'Fx';
            case {2,5}, dof = 'Fy';
            otherwise,  dof = 'Fz';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    fprintf(fid,'\n');
        
%   CASE 6 :   3DFRAME STRUCTURE
else
    Pelemx = Force.Pelemx;
    Pelemy = Force.Pelemy;
    Pelemz = Force.Pelemz;
    ax=Force.ax;
    ay=Force.ay;
    az=Force.az;
    wx = Force.wx;
    wy = Force.wy;
    wz = Force.wz;
    fprintf(fid,'Load Case :  %d\n\n',iload);
    %   PRINT NODAL LOADS 
    fprintf(fid,'   Nodal Loads : \n');
    for k=1 : max(LM( : ));
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(LM' == k);
        elem    = fix(LM_spot(1) / (nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1, nterm) + 1;
        node    = lnods(elem,fix(dof/7) + 1);
        switch(dof)
            case {1,7},  dof = 'Fx';
            case {2,8},  dof = 'Fy';
            case {3,9},  dof = 'Fz';
            case {4,10}, dof = 'Mx';
            case {5,11}, dof = 'My';
            otherwise,   dof = 'Mz';
        end
        % PRINT NODAL LOADS IN GLOBAL DEGREES OF FREEDOM
        if Pnods(k) ~= 0
            fprintf(fid,'     Node :  %2d %s = %14d\n',node, dof, Pnods(k));
        end
    end
    %   PRINT ELEMENT LOADS OR LOADS WHICH ARE APPLIED BETWEEN NODES
    fprintf(fid,'\n   Elemental Loads : \n');
    for k=1 : nelem
        fprintf(fid,'     Element :  %d   Point load (y) = %d at %d from left\n',k,Pelemx(k),ax(k));
        fprintf(fid,'     Element :  %d   Point load (y) = %d at %d from left\n',k,Pelemy(k),ay(k));
        fprintf(fid,'     Element :  %d   Point load (z)= %d at %d from left\n',k,Pelemz(k),az(k));
        fprintf(fid,'                  Distributed load (y) = %d\n',wy(k));
        fprintf(fid,'                  Distributed load (z) = %d\n',wz(k));
    end
    fprintf(fid,'\n');

end
end