clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 10;
complemential = 0;
fr4_thickness = 3.2;
eps_FR4 = 4.6;
tand = 0.02;
L = 8;
dL = 0.25;
fractal(UCDim, L, dL, fr4_thickness, eps_FR4, tand);

