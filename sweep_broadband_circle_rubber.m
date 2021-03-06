clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;

UCDim = 7;
fr4_thickness = 1.;
rubber_thickness = 0.6
mesh_refinement = 3;
L1 = 5.1;
L2 = 2;
w1 = 0.7;

gap = 0.4;

for fr4_thickness = [0.6, 1];
    for rubber_thickness = linspace(0.6, 1, 5);
    circle_broadband_rubber(UCDim, fr4_thickness, rubber_thickness, L1, w1, L2, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
    end;
end;
    