clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

complemential = 0;

eps_subs = 4.4;
tand = 0.02;

UCDim = 13;
fr4_thickness = 3.2;
mesh_refinement = 2;
R = 4.0;
gapwidth = 0.65;
reswidth = 0.5;
overlap = 0.2;
rho = 2.25;
Res = 150;
fcenter = [8.5e9];
fwidth = [4e9];
absorption = [];

%for Res = [250, 225, 200, 175, 150, 125];
for Res = [350, 325, 300, 275];
  absorption = [absorption, 
  optimize_rect_broadband_chipres(UCDim, fr4_thickness, R, gapwidth, rho, reswidth, gapwidth+overlap,...
      Res, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth)];
end;
display(['The minimum integrated reflectance from ' num2str((fcenter-fwidth)/1e9)...
 ' GHz to ' num2str((fcenter+fwidth)/1e9) ' GHz is ' num2str(min(absorption))]);