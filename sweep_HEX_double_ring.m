clear;
clc;
physical_constants;
addpath('./libraries/');

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 0;
w1 = 2;
w2 = 0.5;

UCDim = 20; % UCly = UCDim, UClx = UCDim * (3 sqrt(3))
complemential = 0;
fr4_thickness = 2;


mesh_refinement = 1.5;

eps_FR4 = 4.1;
tand = 0.015;

for w1 = [1.75];
    HEXdouble_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_FR4, tand, mesh_refinement, complemential);
end;

