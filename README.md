# StructuralAnalysisProgram
MATLAB program that performs structural analysis to any arbitrary frame structure with arbitrary DOF.

# Intro:
This was a term project for Matrix Structural Analysis. The general outline of the program (along with the CASAP file) was provided and I was in charge of adding all functionality to the program. The term project report is attached if anyone is interested in more information.

# To Run:
Prepare input file with specifications regarding frame in question. Directions can be found in the input file. <br>
Any type of units would work but consistency within units is key to arrive at correct results.<br>
Please select correct element DOF (istrtp) in input file. <br>
  2-D Frames = 3
  Grid Elements = 4
  3-D Frames = 6

Add input file name to CASAP program and run it. 
(NOTE: Files need to be in same folder)

# Limitations:
Stability analysis and Non-linear geometric analysis available for 2-D frames only. 
To conduct a Stability analysis select -> Stability = 1 in input file.
To conduct a Geometricl Nonlinear Analysis -> GNL = 1 in input file.
Stability and Non-linear geometric analysis are not 
3D plotting is not working properly.

# Moving Forward:
This project was completed a number of years ago. Its a great alternative to having to pay for a 3D frame analysis software and behaves roibustly. I was thinking of transcribing it to Python and adding GUI functionality for input. If anyone would like to take that on please contact me and we could work together.
