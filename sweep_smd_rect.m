clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 2;
fr4_thickness = 2;
L1 = UCDim*8/10;
w1 = L1/8;
Res = 200;
eps_FR4 = 4.4;
Cap = 1e-12; % 'no'
complemential = 0;
for Res = [0.1, 1, 10];
    smd_rect(UCDim, fr4_thickness, L1, w1, Res, Cap, eps_FR4, complemential);
end;