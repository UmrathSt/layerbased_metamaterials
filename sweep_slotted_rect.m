clear;
clc;
physical_constants;
addpath('./libraries');



UCDim = 30;
L1 = 28;
gap = 10;
w = 1.5
complemential = 0;
eps_FR4 = 4.1;
fr4_thickness = 2;

for w = [2];
    slotted_rect(UCDim, fr4_thickness, L1, gap, w, eps_FR4, complemential);
end;
