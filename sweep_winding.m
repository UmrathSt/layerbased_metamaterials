clear;
clc;
physical_constants;
addpath("./libraries");



UCDim = 24;
L = 20;
w = 0.75;
g = 1.5;
N = 6;
fr4_thickness = 2;
tand = 0.015;
mesh_refinement = 1;
complemential = 0;
swap = 1;
eps_subs = 4.1;
alpha = 0;

windings(UCDim, fr4_thickness, L, w, g, N, alpha, eps_subs, tand, mesh_refinement, complemential);
