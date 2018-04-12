clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
scale = 1;
R1 = 0;
R2 = 0.4;
w1 = 0;
w2 = 0.25;

UCDim = 1;
complemential = 0;
fr4_thickness = 1;

tand = 0.015;
mesh_refinement = 2;
swap = 0;
eps_subs = 4.1;

double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, tand, mesh_refinement, complemential);

