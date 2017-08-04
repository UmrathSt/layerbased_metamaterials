clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
scale = 1;
R1 = 10;
w1 = 1.5;

UCDim = 20;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = scale;
swap = 1;
eps_subs = 4.1;
g = 1
for R1 = [8.3, 8.5, 8.7, 8.9, 9.1];
  for fr4_thickness = [1.8, 2, 2.2];
    circular_aperture(UCDim, fr4_thickness, R1, g, eps_subs, tand, mesh_refinement, complemential);
  endfor;
endfor;