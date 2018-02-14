clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6;
fr4_thickness = 0.6;
rubber_thickness = 1;
mesh_refinement = 3;
L1 = 5.5;
w1 = 0.8;
L2 = 3.0;
w2 = 0.5;

L3 = 1.5;


gap = 0.4;

drect_broadband(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
