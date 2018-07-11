clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.6;
tand = 0.02;
scale = 1;
UCDim = 6*scale;
fr4_thickness = 3.2;
mesh_refinement = 3;
Ls = [5.45, 3.45]*scale;
ws = [0.5, 0.5]*scale;
wbars = [0]*scale;
phis = [0, pi/2];
splits = [0, 1.5]*scale;

for fr4_thickness = [3.2];
    open_rect(UCDim, fr4_thickness, Ls, phis, ws, splits, wbars,...
          eps_FR4, tand, mesh_refinement, complemential);
end;