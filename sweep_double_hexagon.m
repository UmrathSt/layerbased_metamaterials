clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
L1 = 12;
w1 = 2;

UCly = 24;
complemential = 0;
mesh_refinement = 1.5;
fr4_thickness = 2;
eps_FR4 = 4.1;
tand = 0.015;
fr4_thickness = 2;
Cu_thickness = 0.15;

for fr4_thickness = [2];
  double_hexagon(UCly, fr4_thickness, Cu_thickness, L1, w1, eps_FR4, ...
        tand, mesh_refinement, complemential);
end;