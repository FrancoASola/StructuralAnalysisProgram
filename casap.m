clear all
clc
%% **********************************************************************************************
%   Main Program:  casap.m
%
%   This is the main program, Computer Aided Structural Analysis Program
%   CASAP.  
%**********************************************************************************************
%%   SET NUMERIC FORMAT
format short e
%   CLEAR MEMORY OF ALL VARIABLES
clear all; clc
%   READ INPUT DATA SUPPLIED BY THE USER
% Read analysis filename
[FileName, PathName]=uigetfile('*.inp','Select input file name');
command=['copy ' FileName ' input_file.m']; status=dos(command);
[Geom,Prop,Force] = input_file; %input_file;
status=dos('erase input_file.m');
%  INITIALIZE OUTPUT FILE
ls=findstr(FileName,'.inp'); fnm=[FileName(1:ls) 'out'];
fid  =  fopen(fnm, 'wt');
%   REASSAMBLE THE ID MATRIX AND CALCULATE THE LM VECTORS
[Geom,Prop,Force,Stiff] = initialization(Geom,Prop,Force);
%   ASSEMBLE THE ELEMENT COORDINATE MATRIX
[Geom] =  elem_coord(Geom);
%   CALCULATE THE LENGTH AND ORIENTATION ANGLE, ALPHA FOR EACH ELEMENT
[Geom] = element_geometry(Geom);
%   CALCULATE THE ELEMENT STIFFNESS MATRIX IN LOCAL COORDINATES.
[Stiff] = element_stiff(Geom,Prop,Stiff);
%   CALCULATE THE ELEMENT STIFFNESS MATRIX IN GLOBAL COORDINATES
[Stiff] = transform_matrices(Geom,Stiff);
%% Check the Convergence and iteration
Big = 10^8; Small = 0.0000000001;
 Stiff.normold = Big; Stiff.norm = Big; iter = 0;
  while abs(Stiff.norm) > Small;
      iter = iter+1;
      Stiff.iter = iter;
      fprintf('Iteration %i norm  %d\n', iter, Stiff.norm);
%   ASSEMBLE THE GLOBAL STRUCTURAL STIFFNESS MATRIX
    [Stiff] = assemble_K(Geom,Stiff);
%   PRINT INPUT DATA
    print_input_data(fid,Geom,Prop,Force,Stiff)
    %   LOOP TO PERFORM ANALYSIS FOR EACH LOAD CASE
    for iload = 1:Force.nload
        Force.iload = iload;
        %   PRINT LOAD CASE DATA TO THE OUTPUT FILE
        print_forces(fid,Geom,Force,Stiff)
        %    DETERMINE THE LOAD VECTOR IN GLOBAL COORDINATES
        [Force] = loads(Geom,Stiff,Force);
        %    CALCULATE THE DISPLACEMENTS
        [Stiff] = displacements(fid,Geom,Stiff,Force);
        %    CALCULATE THE REACTIONS AT THE RESTRAINED DEGREES OF FREEDOM
        reactions(fid,Geom,Stiff,Force);
        %    CALCULATE THE INTERNAL FORCES FOR EACH ELEMENT
      [Force] = internal_forces(fid,Geom,Force,Stiff);
    
        %    END LOOP FOR EACH LOAD CASE
    end
%     Geometric nonlinear analysis
       [Geom,Stiff] = element_stiff_geom(Geom,Force,Stiff);

%     [Geom,Stiff] = new_node_cord(Geom,Stiff);
  end
%   DRAW THE STRUCTURE, IF USER HAS REQUESTED (DRAWFLAG = 1)
plot_structure(Geom)
% CLOSE THE OUTPUT FILE
st = fclose('all');
% Dump Results
% dumpfile(FileName,Geom,Prop,Force,Stiff);
%   END OF MAIN PROGRAM (CASAP.M)
disp('Program completed! - See "casap.out" for complete output');