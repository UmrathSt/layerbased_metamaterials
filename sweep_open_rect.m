clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_FR4 = 4.4;
tand = 0.02;
UCDim = 6;
fr4_thickness = 2;
mesh_refinement = 3;
Ls = [4.5, 2.5];
ws = [0.5, 0.5];
phis = [0, 0];
splits = [0.6, 0.6];

for UCDim = [6];
    open_rect(UCDim, fr4_thickness, Ls, phis, ws, splits,...
          eps_FR4, tand, mesh_refinement, complemential);
end;