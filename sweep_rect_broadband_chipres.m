clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

complemential = 0;

eps_subs = 4.4;
tand = 0.02;

UCDim = 14;
fr4_thickness = 3.2;
mesh_refinement = 2;
R = 3.5;
gapwidth = 0.65;
reswidth = 0.5;
c = 0.5; %split
overlap = 0.15;
rho = 2.75;
Res = 200;
fcenter = [9e9];
fwidth = [4e9];

for Res = [150];
  reflectance = optimize_rect_broadband_chipres(UCDim, fr4_thickness, R, gapwidth, rho, reswidth, gapwidth+overlap,...
      Res, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
end;
display(['The integrated reflectance from ' num2str(fcenter-fwidth) ' to ' num2str(fcenter+fwidth) ' is ' num2str(reflectance)]);