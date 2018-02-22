clear;
clc;
physical_constants;
addpath('./libraries/');

rect_gap = 0;
scale = 1;
R1 = 9.;
L = 2;
N = 40; 
w1 = 1;
w2 = 2;
io = 'Isymmetric';
phi0 = 3*pi/4;

UCDim = 20;
complemential = 0;
fr4_thickness = 2;


mesh_refinement = 2;

eps_FR4 = 4.1;
tand = 0.015;
for w1 = [1.5, 2, 3];
for N = [1];
  single_asy_ring(UCDim, fr4_thickness, R1, w1, N, L, w2, phi0, io, eps_FR4, tand, mesh_refinement, complemential);
end;end;
  %single_asy_ring(UCDim, fr4_thickness, R1, w1, 0, L, w2, eps_FR4, tand, mesh_refinement, complemential);
