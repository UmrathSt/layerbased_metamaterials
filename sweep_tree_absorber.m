clear;
clc;
physical_constants;
addpath('./libraries/');

rect_gap = 0;
scale = 1;
R = 0.3;
w = 0.5;
L1 = 0;
L2 = 4.4;
L3 = 7.0;

UCDim = 16;
complemential = 0;
fr4_thickness = 2;


mesh_refinement = 2;
eps_FR4 = 4.15; % 4.4
tand = 0.015; % 0.02 laut 2014 Paper
Resistance = 220;


for L2 = [6];
  for L3 = [10, 11];
    tree_absorber(UCDim, fr4_thickness, R, L1, w, L2, L3, Resistance, eps_FR4, tand, mesh_refinement, complemential)
  end;
end;