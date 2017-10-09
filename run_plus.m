clear;
clc;
physical_constants;
addpath("./libraries");



w = 2;
UCDim = 22;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.6;
tand = 0.015;
fr4_thickness = 2;
mesh_refinement = 1;
for L = [6];
  plus(UCDim, fr4_thickness, L, w, eps_FR4, tand, mesh_refinement, complemential);

endfor;
