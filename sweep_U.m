clear;
clc;
physical_constants;
addpath('./libraries');


L1 = 8;
L2 = 8;
w1 = 1;
w2 = 1;
UCDim = 20;
complemential = 0;
mesh_refinement = 1.5;

fr4_thickness = 2;
eps_FR4 = 4.1;
tand = 0.015;


U_shapes(UCDim, fr4_thickness, L1, w1, L2, w2, eps_FR4, tand, mesh_refinement, complemential);


