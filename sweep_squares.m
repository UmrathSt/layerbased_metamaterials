clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 20;
L1 = 16;
L2 = 18;
complemential = 0;
fr4_thickness1 = 2;
fr4_thickness2 = 2;

eps_FR4 = 4.6;
film_lz = 0.2;

Rsq = 15;
for Rsq = [5,10,20,30];
    for Rsq2 = [5,10,20,30];
    squares(UCDim, fr4_thickness1, fr4_thickness2, L1, L2, eps_FR4, Rsq, Rsq2, complemential);
end;end;
