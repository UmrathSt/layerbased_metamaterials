clear;
clc;
physical_constants;
addpath('./libraries');



UCDim = 20;
L = 18;
w = 1;
g = 1.5;
N = 4;

fr4_thickness = 1;
rubber_thickness = 1;

tand = 0.015;
mesh_refinement = 1;
complemential = 0;
swap = 1;
eps_subs = 4.1;
alpha = 0;
for N = [2, 3, 4, 5, 6, 7];
for g = [1.5, 2, 2.5, 3];
    windings(UCDim, fr4_thickness, rubber_thickness, L, w, g, N, alpha, eps_subs, tand, mesh_refinement, complemential);
end;
end;
