clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;
scale = 0.75;

UCDim = 6*scale;
fr4_thickness = 0.6;
rubber_thickness = 0.4; # <--- 0.4 und 0.2 versuchen!
mesh_refinement = 6;
L1 = 4.5*scale;
w1 = 0.75*scale;
L2 = 2.6*scale;
w2 = 0.5*scale;

L3 = 1*scale;


gap = 0.3*scale;

drect_broadband(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
