<<<<<<< HEAD
function [Geom,Prop,Force,Stiff] = initialization(Geom,Prop,Force)
%************************************************************************************************
%  SCRIPTFILE NAME:   IDRASMBL.M
%
%  MAIN FILE      :   CASAP
%
%  Description    :   This file re-assambles the ID matrix such that the restrained
%                     degrees of freedom are given negative values and the unrestrained
%                     degrees of freedom are given incremental values beginning with one
%                     and ending with the total number of unrestrained degrees of freedom.
% nterm : size of stiffness matrix in global coordinate system
%
%************************************************************************************************

%   TAKE CARE OF SOME INITIAL BUSINESS: TRANSPOSE THE PNODS ARRAY
Force.Pnods  =  Force.Pnods.';
%   SET THE COUNTER TO ZERO
count     =   1;
negcount  =  -1;
%   REASSEMBLE THE ID MATRIX
if  Geom.istrtp == 1       %  BEAM
    ndofpn = 2;
    nterm = 3; 
elseif  Geom.istrtp == 2   %  2DTRUSS
    ndofpn = 2;
    nterm = 4;
elseif  Geom.istrtp == 3   %  2DFRAME
    ndofpn = 3;
    nterm = 6;
elseif  Geom.istrtp == 4   %  GRID
    ndofpn = 3;
    nterm = 6;
elseif  Geom.istrtp == 5   %  3DTRUSS
    ndofpn = 2;
    nterm = 6;
elseif  Geom.istrtp == 6   %  3DFRAME
    ndofpn = 6;
    nterm = 12;
else
    error('Incorrect structure type specified')
end
Stiff.ndofpn = ndofpn;
Stiff.nterm = nterm;
%   SET THE ORIGINAL ID MATRIX TO TEMP MATRIX

Geom.orig_ID  =  Geom.ID;

%   REASSEMBLE THE ID MATRIX, SUBSTITUTING RESTRAINED DEGREES OF FREEDOM WITH NEGATIVES,
%   AND NUMBERING GLOBAL DEGREES OF FREEDOM

k  =  count;

for inode = 1 : Geom.npoin
    for jnode = 1 : ndofpn
        if Geom.orig_ID(inode,jnode)  ==  0
            Geom.ID(inode,jnode)  =  k
            k  = k+1;
        end    
    end
end 
for inode = 1 : Geom.npoin
    for jnode = 1:ndofpn
        if Geom.orig_ID(inode,jnode)  ==  1; 
            Geom.ID(inode,jnode)  =  -k ; % assign a negative value to the dof whcih are fixed
            k  = k+1;
        end    
    end
end 


Geom.LM_n = Geom.ID;
%  ASSEMBLE THE LM VECTOR 
for ielem = 1 : Geom.nelem
    LM(ielem,:)  =  [Geom.ID(Geom.lnods(ielem,1),:),Geom.ID(Geom.lnods(ielem,2),:)];
end
Geom.LM = LM;
clear LM;
end


=======
function [Geom,Prop,Force,Stiff] = initialization(Geom,Prop,Force)
%************************************************************************************************
%  SCRIPTFILE NAME:   IDRASMBL.M
%
%  MAIN FILE      :   CASAP
%
%  Description    :   This file re-assambles the ID matrix such that the restrained
%                     degrees of freedom are given negative values and the unrestrained
%                     degrees of freedom are given incremental values beginning with one
%                     and ending with the total number of unrestrained degrees of freedom.
% nterm : size of stiffness matrix in global coordinate system
%
%************************************************************************************************

%   TAKE CARE OF SOME INITIAL BUSINESS: TRANSPOSE THE PNODS ARRAY
Force.Pnods  =  Force.Pnods.';
%   SET THE COUNTER TO ZERO
count     =   1;
negcount  =  -1;
%   REASSEMBLE THE ID MATRIX
if  Geom.istrtp == 1       %  BEAM
    ndofpn = 2;
    nterm = 3; 
elseif  Geom.istrtp == 2   %  2DTRUSS
    ndofpn = 2;
    nterm = 4;
elseif  Geom.istrtp == 3   %  2DFRAME
    ndofpn = 3;
    nterm = 6;
elseif  Geom.istrtp == 4   %  GRID
    ndofpn = 3;
    nterm = 6;
elseif  Geom.istrtp == 5   %  3DTRUSS
    ndofpn = 2;
    nterm = 6;
elseif  Geom.istrtp == 6   %  3DFRAME
    ndofpn = 6;
    nterm = 12;
else
    error('Incorrect structure type specified')
end
Stiff.ndofpn = ndofpn;
Stiff.nterm = nterm;
%   SET THE ORIGINAL ID MATRIX TO TEMP MATRIX

Geom.orig_ID  =  Geom.ID;

%   REASSEMBLE THE ID MATRIX, SUBSTITUTING RESTRAINED DEGREES OF FREEDOM WITH NEGATIVES,
%   AND NUMBERING GLOBAL DEGREES OF FREEDOM

k  =  count;

for inode = 1 : Geom.npoin
    for jnode = 1 : ndofpn
        if Geom.orig_ID(inode,jnode)  ==  0
            Geom.ID(inode,jnode)  =  k
            k  = k+1;
        end    
    end
end 
for inode = 1 : Geom.npoin
    for jnode = 1:ndofpn
        if Geom.orig_ID(inode,jnode)  ==  1; 
            Geom.ID(inode,jnode)  =  -k ; % assign a negative value to the dof whcih are fixed
            k  = k+1;
        end    
    end
end 


Geom.LM_n = Geom.ID;
%  ASSEMBLE THE LM VECTOR 
for ielem = 1 : Geom.nelem
    LM(ielem,:)  =  [Geom.ID(Geom.lnods(ielem,1),:),Geom.ID(Geom.lnods(ielem,2),:)];
end
Geom.LM = LM;
clear LM;
end


>>>>>>> f5562fe9cc4b5a6d3e97162c1ad8140984111333
