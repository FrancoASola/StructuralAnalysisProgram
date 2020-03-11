function reactions(fid,Geom,Stiff,Force)
%**********************************************************************************************
%   Scriptfile name :   react3.m    (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       When this file is called, it calculates the reactions at the restrained degrees of
%       freedom.
%
%   Variable Descriptions:
%
%   number_gdofs        =   number of global dofs
%   Kut                 =   upper left part of aug stiffness matrix, normal structure stiff matrix
%   count               =   counter
%   feamatrix_global    =   matrix containing resulting fixed end actions in global coordinates
%   temp3               =   temporary variable
%   temp4               =   temporary variable
%   fea_vector_react    =   vector of fixed end action in restrained dofs (reaction)
%   Reactions           =   reactions at restrained degrees of freedom
%   Delta               =   vector of displacements
%   Kuu                 =   lower rigth part of Augmented structural stiffness matrix
%
%       Simplified for 2D Frame Case only
%
%**********************************************************************************************

    for i=1:1:size(Stiff.Kut,1)
        count = (Stiff.number_gdofs  +  i) * (-1);
        temp3 = Force.feamatrix_global(find(Geom.LM == count));
        temp4 = sum(temp3);
        fea_vector_react(i,1) = - temp4;
    end 
    Reactions = (Stiff.Kut * Stiff.Delta) + fea_vector_react;
 
%   PRINT REACTIONS WITH NODE INFO
fprintf(fid,'   Reactions:\n');
%   IF THERE ARE UNRESTRAINED NODES
if Geom.istrtp == 3
    if Stiff.number_gdofs > 0   
      
    for k = max(Geom.LM(:)) + 1:max(abs(Geom.LM(:)))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' == -k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1, Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/4) + 1); 
        switch(dof)         
        case {1,4}, dof = 'Fx';
        case {2,5}, dof = 'Fy';
        otherwise,  dof = 'M ';
        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(k-max(Geom.LM(:))));
    end
    
%   IF ALL THE NODES ARE RESTRAINED
else 
    for k = -1:-1:min(Geom.LM(:))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' ==  k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1,Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/4) + 1);
        switch(dof)
            case {1,4}, dof = 'Fx';
            case {2,5}, dof = 'Fy';
            otherwise,  dof = 'M ';
        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(-k));
    end
    end
end
if Geom.istrtp == 4
    if Stiff.number_gdofs > 0   
      
    for k = max(Geom.LM(:)) + 1:max(abs(Geom.LM(:)))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' == -k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1, Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/4) + 1); 
        switch(dof)         
        case {1,4}, dof = 'Mx';
        case {2,5}, dof = 'Fy';
        otherwise,  dof = 'Mz ';
        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(k-max(Geom.LM(:))));
    end
    
%   IF ALL THE NODES ARE RESTRAINED
else 
    for k = -1:-1:min(Geom.LM(:))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' ==  k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1,Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/4) + 1);
        switch(dof)
            case {1,4}, dof = 'Fx';
            case {2,5}, dof = 'Fy';
            otherwise,  dof = 'M ';
        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(-k));
    end
    end
end
if Geom.istrtp == 6
     if Stiff.number_gdofs > 0 
    for k = max(Geom.LM(:)) + 1:max(abs(Geom.LM(:)))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' == -k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1)-1, Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/7) + 1); 
        switch(dof)
            case {1,7},  dof = 'Fx';
            case {2,8},  dof = 'Fy';
            case {3,9},  dof = 'Fz';
            case {4,10}, dof = 'Mx';
            case {5,11}, dof = 'My';
            otherwise,   dof = 'Mz';

        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(k-max(Geom.LM(:))));
    end
    
%   IF ALL THE NODES ARE RESTRAINED
else
    for k = -1:-1:min(Geom.LM(:))
        % WORK BACKWARDS WITH LM MATRIX TO FIND NODE # AND DOF
        LM_spot = find(Geom.LM' ==  k);
        elem    = fix(LM_spot(1) / (Stiff.nterm + 1)) + 1;
        dof     = mod(LM_spot(1) - 1,Stiff.nterm) + 1;
        node    = Geom.lnods(elem, fix(dof/7) + 1);
        switch(dof)
         case {1,7},  dof = 'Fx';
            case {2,8},  dof = 'Fy';
            case {3,9},  dof = 'Fz';
            case {4,10}, dof = 'Mx';
            case {5,11}, dof = 'My';
            otherwise,   dof = 'Mz';
        end
        % PRINT THE REACTIONS
        fprintf(fid,'     (Node: %2d %s) %14d\n',node, dof, Reactions(-k));
    end
    
    end
fprintf(fid,'\n');
end
end

