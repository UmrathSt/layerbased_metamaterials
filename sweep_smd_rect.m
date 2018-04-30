clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 10;
fr4_thickness = 0.4;
L1 = 9.5;
w1 = 1;
Res = 50;
eps_FR4 = 4.4;
Cap = 50e-12;
complemential = 0;
for Res = [100];
    smd_rect(UCDim, fr4_thickness, L1, w1, Res, Cap, eps_FR4, complemential);
end;