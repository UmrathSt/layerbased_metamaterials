clear;
clc;
physical_constants;
addpath('./libraries');



UCDim = 20;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.4;
tand = 0.015;
fr4_thickness = 2;
mesh_refinement = 1;
R = 9.8
w = 1.5
phi0 = 3*pi/4;
DeltaPhi = pi/16;
for L = [6];
  split_ring(UCDim, fr4_thickness, R, w, phi0, DeltaPhi, eps_FR4, tand, mesh_refinement, complemential);
end;
