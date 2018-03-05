clear;
clc;
physical_constants;
addpath('./libraries');

scale = 0.5;

UCDim = 20*scale;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.4;
tand = 0.015;
fr4_thickness = 2;
mesh_refinement = 2;
R = 9.8*scale
w = 1.5*scale
phi0 = 3*pi/4;
DeltaPhi = 0;
polarization = 'y';
for polarization = ['x', 'y'];
  split_ring(UCDim, fr4_thickness, R, w, phi0, DeltaPhi, eps_FR4, tand, polarization, mesh_refinement, complemential);
end;
  % closed ring!
% split_ring(UCDim, fr4_thickness, R, w, phi0, 0, eps_FR4, tand, polarization, mesh_refinement, complemential);
