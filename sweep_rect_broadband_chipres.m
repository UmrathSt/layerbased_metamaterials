clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_subs = 4.4;
tand = 0.02;

UCDim = 14;
fr4_thickness = 3.8;
mesh_refinement = 2;
R = 3.8;
w = 0.65;
c = 0.5;
rho = 3;
Res = 130;

for Ohm = [170, 160];
  rect_broadband_chipres(UCDim, fr4_thickness, R, w, rho, c,...
    Ohm, eps_subs, tand, mesh_refinement, complemential);
end;

for RHO = [2, 2.25, 2.5, 2.75, 3.25];
  broadband_chipres(UCDim, lz, R, w, RHO, c,...
    Res, eps_subs, tand, mesh_refinement, complemential);
end;

for gapwidth = [0.5, 0.7];
  broadband_chipres(UCDim, fr4_thickness, R, gapwidth, rho, c,...
    Res, eps_subs, tand, mesh_refinement, complemential);
end;