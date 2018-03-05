clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;


eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6;
fr4_thickness = 1.6;
mesh_refinement = 3;
L1 = 5;
L2 = 1.9;
w1 = 0.8;
gap = 0.42;

rect_broadband_lorentz(UCDim, fr4_thickness, L1, w1, L2, gap, eps_FR4, tand, mesh_refinement, complemential);
rect_broadband_const(UCDim, fr4_thickness, L1, w1, L2, gap, eps_FR4, tand, mesh_refinement, complemential);

    