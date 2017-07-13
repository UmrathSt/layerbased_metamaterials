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
swap = 1;
eps_subs = 4.1;
for eps_subs = [4.0, 4.2, 4.4, 4.6, 4.8, 5.0];
  double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, tand, mesh_refinement, complemential);
endfor;
eps_subs = 4.1;
for tand = [0.01, 0.015, 0.02, 0.025, 0.03];
  double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, tand, mesh_refinement, complemential);
endfor;