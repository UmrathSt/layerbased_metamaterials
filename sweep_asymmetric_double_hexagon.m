clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
scale = 4;
L1 = 3.0;
w1 = 0.5;
L3 = 3;
w3 = 0.55;

L2 = 0;
w2 = 0;

UCly = 6;
complemential = 0;
mesh_refinement = 4;
eps_FR4 = 4.1;
tand = 0.015;
fr4_thickness = [0.15]
Cu_thickness = 0.1;

for w1 = [0.5];
  asymmetric_double_hexagon(UCly, fr4_thickness, Cu_thickness, L1, w1, L2, w2, L3, w3, eps_FR4, ...
        tand, mesh_refinement, complemential);
end;