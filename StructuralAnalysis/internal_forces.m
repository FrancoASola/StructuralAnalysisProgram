function[Force,Stiff]= internal_forces(fid,Geom,Force,Stiff)
%**********************************************************************************************
%   Scriptfile name :   intern3.m   (for 2D-Frame, Grid and 3D-Frame structures)
%
%   Main program    :   casap.m
%
%       When this file is called, it calculates the internal forces in all elements.
%
%   Variable Descriptions:
%
%   Pglobe           =   vector containing the nodal load in global coordinates
%   Plocal           =   vector containing the nodal load in local coordinates
%   ielem            =   counter for loop
%   nelem            =   number of elements in the structure
%   elem_delta       =   vector of generalized nodal displacements
%   count            =   counter
%   Delta            =   vector of displacements for the global degrees of freedom
%   feamatrix_global =   matrix containing resulting fixed end actions in global coordinates
%   rotation         =   rotation matrix containing all elements info
%
%       Simplified for 2D Frame Case only
%
%**********************************************************************************************

%   INITIALIZE P LOCAL AND GLOBAL TO ALL ZEROS
Pglobe       = zeros(Stiff.nterm,Geom.nelem);
Force.Plocal = Pglobe;

fprintf(fid,'   Internal Forces:');
% LOOP FOR EACH ELEMENT
for ielem = 1 : Geom.nelem
    % FIND ALL LOCAL DISPLACEMENTS
    elem_delta = zeros(Stiff.nterm,1);
    for idof = 1 : Stiff.nterm
        gdof = Geom.LM(ielem,idof);
        if gdof < 0
            elem_delta(idof) = 0;
        else
            elem_delta(idof) =Stiff.Delta(gdof);
        end
    end
           elem_delta_global=Stiff.rotation(:,:,ielem)*elem_delta;
   %SOLVE FOR ELEMENT FORCES (GLOBAL)
      %ROTATE FORCES FROM GLOBAL TO LOCAL COORDINATES
   Force.Plocal(:,ielem) =  Stiff.k(:,:,ielem)*elem_delta_global-Force.feamatrix_global(ielem,:)';

   %PRINT RESULTS
   fprintf(fid,'\n      Element: %2d\n',ielem);
   for idof = 1 : Stiff.nterm
      if idof == 1
         fprintf(fid,'       At Node: %d\n',Geom.lnods(ielem,1));
      end
      if idof == 4
         fprintf(fid,'       At Node: %d\n',Geom.lnods(ielem,2));
      end
      switch(idof)
      case {1,4}, dof = 'Fx';
      case {2,5}, dof = 'Fy';
      otherwise , dof = 'M ';
      end
      fprintf(fid,'          (Global : %s ) %14d',dof, Pglobe(idof,ielem));
      fprintf(fid,'    (Local : %s ) %14d\n',dof, Force.Plocal(idof,ielem));
   end
end
fprintf(fid,'\n_________________________________________________________________________\n\n');