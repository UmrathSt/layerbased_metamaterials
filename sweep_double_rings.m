clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
R1 = 9.8;
R2 = 5.1;
w1 = 1.5;
w2 = 1.5;
UCDim = 20;
complemential = 0;
mesh_refinement = 0;
fr4_thickness = 0.2;
eps_FR4 = 4.4;
tand = 0.015;
fr4_thickness = 2;
double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_FR4, tand, mesh_refinement, complemential);
