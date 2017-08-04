clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
scale = 1;
L1 = 18;
L2 = 15;

UCDim = 40;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = scale;
swap = 1;
eps_subs = 4.1;
rect_chessboard(UCDim, fr4_thickness, L1, L2, eps_subs, tand, mesh_refinement, complemential, swap);
