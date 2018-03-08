clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_subs = 4.4;
tand = 0.02;

UCDim = 14;
fr4_thickness = 3.2;
mesh_refinement = 3;
R = 4;
gapwidth = 0.60;
reswidth = 0.5;
c = 0.5; %split
s = 0.65;
rho = 3.5;
Res = 250;


for gapwidth = [0.6, 0.55, 0.5];
  rect_broadband_chipres(UCDim, fr4_thickness, R, gapwidth, rho, reswidth, s,...
    Res, eps_subs, tand, mesh_refinement, complemential);
end;