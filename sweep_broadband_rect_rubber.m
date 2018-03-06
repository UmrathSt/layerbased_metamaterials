clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.3;
tand = 0.02;

UCDim = 7;
fr4_thickness = 1.6;
rubber_thickness = 0;
mesh_refinement = 3;
L1 = 5.1;
L2 = 1.85;
w1 = 0.7;

gap = 0.4;

for fr4_thickness = [0.36];
    for rubber_thickness = [1.7, 1.8];
    rect_broadband_rubber(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
    end;
end;
    