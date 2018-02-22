clear;
clc;
physical_constants;
addpath('./libraries');


L = 18;
slitL = 1.5;
slitW = 0.5;
slitN = 10; % number of slits to be distributed

UCDim = 20;
complemential = 0;
fr4_thickness = 3;

tand = 0.015;
mesh_refinement = 1;
swap = 0;
eps_subs = 4.1;
random = 0; % randomly choose the width of the gaps betwen 0 and slitW

for slitN = [10];
  rect(UCDim, fr4_thickness, L, slitN, slitL, slitW, ...
      eps_subs, tand, mesh_refinement, complemential, random);
%rect(UCDim, fr4_thickness, L, 0, slitG, ...
%        eps_subs, tand, mesh_refinement, complemential);
end;