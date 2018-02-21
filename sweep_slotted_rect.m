clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;
scale = 1.5;
UCDim = 6*scale;
fr4_thickness = 0.2;
rubber_thickness = 1.6;

mesh_refinement = 3;
L1 = 4.7*scale;
w1 = 0.6*scale;
L2 = 1.9*scale;
w2 = 0.6*scale;
L3 = 2.5*scale;
gap = 0.45*scale;
kappa = 0.5;
for rubber_thickness = [3];
for kappa = [0.25, 0.75, 1.25];
  slotted_rect(UCDim, fr4_thickness, rubber_thickness, kappa, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
end;end;