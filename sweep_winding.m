clear;
clc;
physical_constants;
addpath('./libraries');



UCDim = 20;
L = 18;
w = 0.5;
g = 1.5;
N = 4;

fr4_thickness = 3;
rubber_thickness = 0.2;

tand = 0.02;
mesh_refinement = 1;
complemential = 0;
swap = 1;
eps_subs = 4.6;
alpha = 0;
Rsq = 50;
g = 2;
for N = [5];
for Rsq = [50, 150, 250, 350];                                                                                               
    windings(UCDim, fr4_thickness, rubber_thickness, Rsq, L, w, g, N, alpha, eps_subs, tand, mesh_refinement, complemential);
end;
end;
