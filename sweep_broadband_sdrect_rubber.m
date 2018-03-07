clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;
scale = 1.4;
eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6.5;
fr4_thickness = 1.6;
rubber_thickness = 0;
mesh_refinement = 3;
L0 = 5.5;
w0 = 0.5;
L1 = 5.1/scale;
L2 = 1.8/scale;
w1 = 0.7/scale;

gap = 0.4/scale;
for fr4_thickness = [0.2];
for rubber_thickness = [2, 1.8];
sdrect_broadband_rubber(UCDim, fr4_thickness, rubber_thickness, L0, w0, ...
      L1, w1, L2, gap, gap, eps_FR4, tand, mesh_refinement, complemential);
end;end;
    