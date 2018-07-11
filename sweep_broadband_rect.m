clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 1.5;
tand = 0.01;
tand2 = 0.01;

UCDim = 10;
fr4_thickness = 0.4;
mesh_refinement = 3;
L1 = 8;
L2 = 3.9;
w1 = 0.8;
flat = 0;
gap = 0.42;

for Rsq = [0.003];
    rect_broadband(UCDim, fr4_thickness, L1, w1, L2, ...
          gap, eps_FR4, Rsq, tand, tand2, flat, mesh_refinement, complemential);
end;