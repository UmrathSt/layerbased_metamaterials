clear;
clc;
physical_constants;
addpath('./libraries/');

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 5.1;
w1 = 1.5;
w2 = 0.5;

UCDim = 20;
complemential = 0;
fr4_thickness = 2;


mesh_refinement = 1.5;

eps_FR4 = 4.1;
tand = 0.015;
Resistance = 100;
for Resistance = [2.5, 5, 7.5, 10];
  resistive_double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, ...
        eps_FR4, tand, mesh_refinement, complemential, Resistance);
end;