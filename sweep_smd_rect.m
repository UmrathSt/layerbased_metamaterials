clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 10;
fr4_thickness = 0.4;
L1 = 8;
w1 = 1;
Res = 200;
eps_FR4 = 4.4;
Cap = 'no';
complemential = 0;
for Res = [0.1, 1, 10, 100, 200, 300, 400];
    smd_rect(UCDim, fr4_thickness, L1, w1, Res, Cap, eps_FR4, complemential);
end;