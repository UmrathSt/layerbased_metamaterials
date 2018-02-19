clear;
clc;
physical_constants;
addpath('./libraries/');



R1 = 5.5;
R2 = 3.75;
w1 = 1;
w2 = 1;
gap = 1.5;

UCDim = 24;
complemential = 0;
fr4_thickness = 1.4;


mesh_refinement = 2;

eps_FR4 = 4.1;
tand = 0.015;

double_4x4_split_ring(UCDim, fr4_thickness, R1, w1, R2, w2, ...
        eps_FR4, tand, mesh_refinement, complemential, gap);

