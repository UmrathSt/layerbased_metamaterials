clear;
clc;
physical_constants;
addpath('./libraries');



UCDim = 10;
L = 8;
w = 0.5;
g = 0.5;
N = 4;

fr4_thickness = 1;
rubber_thickness = 0.2;

tand = 0.02;
mesh_refinement = 1;
complemential = 0;

eps_subs = 4.6;
alpha = 0;
Rsq = 50;
g = 1;
for N = [4];
for Rsq = [500];                                                                                               
    windings(UCDim, fr4_thickness, rubber_thickness, Rsq, L, w, g, N, alpha, eps_subs, tand, mesh_refinement, complemential);
end;
end;
