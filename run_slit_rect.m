clear;
clc;
physical_constants;
addpath('./libraries');


L = 18;
slitL = 2;
slitW = 1;
slitN = 10; % number of slits to be distributed

UCDim = 20;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = 1;
swap = 0;
eps_subs = 4.1;
for slitN = [6, 7, 8, 9];
  rect(UCDim, fr4_thickness, L, slitN, slitL, slitW, ...
      eps_subs, tand, mesh_refinement, complemential);
%rect(UCDim, fr4_thickness, L, 0, slitG, ...
%        eps_subs, tand, mesh_refinement, complemential);
end;