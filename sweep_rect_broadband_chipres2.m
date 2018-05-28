clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

complemential = 0;

eps_subs = 4.6;
tand = 0.02;

UCDim = 14.25;
fr4_thickness = 3.2;
mesh_refinement = 2;
L1 = 4;
L2 = 2.5;
gapwidth = 0.60;
gapwidth2 = 0.6;
reswidth = 0.5;
rho = 2.5;
fcenter = [9.25e9];
fwidth = [3.5e9];
absorption = [];
for UCDim = [14.25];
for Res1 = [750];
for Res2 = [30];
  absorption = [absorption, ...
  optimize_rect_broadband_chipres2(UCDim, fr4_thickness, L1, L2, rho, gapwidth, gapwidth2,...
reswidth, Res1, Res2, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth)];
end;
end;end;
display(['The minimum integrated reflectance from ' num2str((fcenter-fwidth)/1e9)...
 ' GHz to ' num2str((fcenter+fwidth)/1e9) ' GHz is ' num2str(min(absorption))]);