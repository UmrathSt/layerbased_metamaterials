clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 5.1;
w1 = 1.5;
w2 = 0.5;
UCDim = 20;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = scale;
swap = 0;
eps_subs = 4.1;
alpha = pi/2;
N = 8;
rlength = 2*w1;
rwidth = w1/2;

chiral_double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, alpha, N, rlength, rwidth, eps_subs, tand, mesh_refinement, complemential, swap);
