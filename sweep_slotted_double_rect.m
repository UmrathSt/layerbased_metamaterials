clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;
scale = 1.5;
UCDim = 7;
fr4_thickness = 0.2;
rubber_thickness = 1.6;

mesh_refinement = 3;
L0 = 6.2;
w0 = 0.5;
L1 = 4.5;
w1 = 0.6;
L2 = 4.5;
w2 = 0.6;
L3 = 2.5;
gap = 0.45;
kappa = 1;
for fr4_thickness = [0.8, 1, 1.2];
for rubber_thickness = [0.8, 1,1.2,1.4,1.6,1.8,2];
  for kappa = [1.45];
  slotted_double_rect(UCDim, fr4_thickness, rubber_thickness, kappa, L0, w0, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
end;end;end;