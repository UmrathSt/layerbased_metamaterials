clear;
clc;
physical_constants;
addpath('./libraries');


complemential = 0;

eps_subs = 4.4;
tand = 0.02;

UCDim = 14;
fr4_thickness = 1.9;
mesh_refinement = 2;
R = 3.8;
w = 0.65;
c = 0.5;
rho = 3;
Res = 130;

for Ohm = [350];
  broadband_chipres(UCDim, fr4_thickness, R, w, rho, c,...
    Ohm, eps_subs, tand, mesh_refinement, complemential);
end;

for lz = [2];
  broadband_chipres(UCDim, lz, R, w, rho, c,...
    Res, eps_subs, tand, mesh_refinement, complemential);
end;

for gapwidth = [0.5, 0.7];
  broadband_chipres(UCDim, fr4_thickness, R, gapwidth, rho, c,...
    Res, eps_subs, tand, mesh_refinement, complemential);
end;