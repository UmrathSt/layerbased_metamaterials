clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 9.8;
w1 = 1.5;
w2 = 1.5;

UCDim = 20;
complemential = 0;
fr4_thickness = 1;

tand = 0.015;
mesh_refinement = 2;
swap = 0;
eps_subs = 4.4;
 
double_ring_trans(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, ...
          tand, mesh_refinement, complemential);
