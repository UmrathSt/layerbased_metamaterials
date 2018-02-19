clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;

UCDim = 6;
fr4_thickness = 1.6;

mesh_refinement = 3;
L1 = 5;
w1 = 0.6;
L2 = 3.2;
w2 = 0.6;
L3 = 2.5;
gap = 0.45;

for L1 = [4.7, 5];
    for L2 = [2.5, 2.75, 3, 3.2];
 
 for w2 = [0.25, 0.5, 0.7];
    slotted_rect(UCDim, fr4_thickness, L1, w1, L2, w2, L3, ...
          gap, eps_FR4, tand, mesh_refinement, complemential);
end;
end;end;