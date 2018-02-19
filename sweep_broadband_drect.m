clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6;
fr4_thickness = 0.2;
rubber_thickness = 1.6;
mesh_refinement = 3;
L1 = 4.7;
w1 = 0.6;
L2 = 1.9;
w2 = 0.8;
L3 = 1.5;
kappa = 20;
gap = 0.45;

for scale = [1];
    drect_broadband(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, kappa, scale, mesh_refinement, complemential);
end;
