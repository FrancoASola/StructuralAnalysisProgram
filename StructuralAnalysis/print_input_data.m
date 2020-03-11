function print_input_data(fid,Geom,Prop,Force,Stiff)
%**********************************************************************************************
%   Scriptfile name  :    print_general_info.m
%
%   Main program     :    casap.m
%
%       This file prints the general structure info to the output file
%       w.r.t the type of structure under analysis
%       1    =    BEAM
%       2    =    2DTRUSS
%       3    =    2DFRAME
%       4    =    GRID
%       5    =    3DTRUSS
%       6    =    3DFRAME
%
%**********************************************************************************************
%% Recover some of the data
iter = Stiff.iter;
istrtp = Geom.istrtp;
npoin = Geom.npoin;
nelem = Geom.nelem;
ID = Geom.ID;
nodecoor = Geom.nodecoor;
lnods = Geom.lnods;
nload = Force.nload;
E = Prop.E;
G = Prop.G;
A = Prop.A;
Ix = Prop.Ix;
Iy = Prop.Iy;
Iz = Prop.Iz;
LM = Geom.LM;
%%
fprintf(fid,'\n_________________________________________________________________________\n\n');
fprintf(fid,'Number of Iteration :  %d\n' ,iter);
if iter == 1
    fprintf(fid,'\n_________________________________________________________________________\n\n');
    fprintf(fid,'Number of Nodes :  %d\n' , npoin);
    fprintf(fid,'Number of Elements :  %d\n'  , nelem);
    fprintf(fid,'Number of Load Cases :  %d\n', nload);
    % If all there are free degrees of freedom
    if max(LM( : ))  >  0
        fprintf(fid,'Number of Restrained dofs :  %d\n',abs(min(LM( : )))-max(LM( : )));
        fprintf(fid,'Number of Free dofs :  %d\n',max(LM( : )));
        % If all the degrees of freedom are restrained
    else
        fprintf(fid,'Number of Restrained dofs :  %d\n',abs(min(LM( : ))));
        fprintf(fid,'Number of Free dofs :  %d\n', 0);
    end

    %   CASE 1 :   BEAM STRUCTURE
    if istrtp  ==  1
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' Y '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Rot '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'   E = %d Iz = %d \n',E(ielem),Iz(ielem));
        end

        %   CASE 2 :   2DTRUSS STRUCTURE
    elseif istrtp  ==  2
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' X '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Y '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'     E = %d A = %d \n', E(ielem),A(ielem));
        end

        %   CASE 3 :   2DFRAME STRUCTURE
    elseif istrtp  ==  3
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' X '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Y '];
            end
            if(ID(inode,3)) > 0
                freedof = [freedof ' ROT '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'   E = %d A = %d Iz = %d \n',E(ielem),A(ielem),Iz(ielem));
        end

        %   CASE 4 :   GRID STRUCTURE
    elseif istrtp  ==  4
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2),nodecoor(inode,3));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' RotX '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Y '];
            end
            if(ID(inode,3)) > 0
                freedof = [freedof ' RotZ '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'   E = %d G = %d Iz = %d Ix = %d \n',E(ielem),G(ielem),Iz(ielem),Ix(ielem));
        end

        %   CASE 5 :   3DTRUSS STRUCTURE
    elseif istrtp  ==  5
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2),nodecoor(inode,3));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' X '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Y '];
            end
            if(ID(inode,3)) > 0
                freedof = [freedof ' Z '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'     E = %d A = %d \n', E(ielem),A(ielem));
        end

        %   CASE 6 :   3DFRAME STRUCTURE
    else
        fprintf(fid,'\nNode Info : \n');
        for inode = 1 : npoin
            fprintf(fid,'     Node %d (%d,%d,%d)\n',inode,nodecoor(inode,1),nodecoor(inode,2),nodecoor(inode,3));
            freedof = ' ';
            if(ID(inode,1)) > 0
                freedof = [freedof ' X '];
            end
            if(ID(inode,2)) > 0
                freedof = [freedof ' Y '];
            end
            if(ID(inode,3)) > 0
                freedof = [freedof ' Z '];
            end
            if(ID(inode,4)) > 0
                freedof = [freedof ' RotX '];
            end
            if(ID(inode,5)) > 0
                freedof = [freedof ' RotY '];
            end
            if(ID(inode,6)) > 0
                freedof = [freedof ' RotZ '];
            end
            if freedof == ' '
                freedof = ' none; node is fixed';
            end
            fprintf(fid,'        Free dofs : %s\n',freedof);
        end
        fprintf(fid,'\nElement Info : \n');
        for ielem = 1 : nelem
            fprintf(fid,'     Element %d (%d- > %d)',ielem,lnods(ielem,1),lnods(ielem,2));
            fprintf(fid,'   E = %d A = %d G = %d Ix = %d Iy = %d Iz = %d \n',E(ielem),A(ielem),G(ielem),Ix(ielem),Iy(ielem),Iz(ielem));
        end
    end
else
    fprintf(fid,'\n_________________________________________________________________________\n\n');
end
end