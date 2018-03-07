clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6;
fr4_thickness = 1.6;
rubber_thickness = 0;
mesh_refinement = 3;
L1 = 4.7;
L2 = 1.9;
w1 = 0.8;

gap = 0.4;

rect_broadband_rubber(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);

    