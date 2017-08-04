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
R3 = 9.5;
R4 = 4.7;
w3 = 1.5;
w4 = 0.5;
UCDim = 40;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = 2;
swap = 1;
eps_subs = 4.1;

double_ring_chessboard(UCDim, fr4_thickness, R1, w1, R2, w2, R3, w3, R4, w4, eps_subs, tand, mesh_refinement, complemential, swap);
