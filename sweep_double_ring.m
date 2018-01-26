clear;
clc;
physical_constants;
addpath('./libraries/');

rect_gap = 0;
scale = 1;
R1 = 10.0;
R2 = 10.8/2.8;%10.8/3;
w1 = 4;
w2 = 2.5;

UCDim = 21;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = 1.5;
swap = 1;
eps_FR4 = 4.1;
tand = 0.015;

double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_FR4, tand, mesh_refinement, complemential);
single_ring(UCDim, fr4_thickness, R1, w1, eps_FR4, tand, mesh_refinement, complemential);
single_ring(UCDim, fr4_thickness, R2, w2, eps_FR4, tand, mesh_refinement, complemential);
