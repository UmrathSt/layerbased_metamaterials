clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;

UCDim = 60;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.1;
tand = 0.015;
L = 56;
dL = 2
fr4_thickness = 3;
fractal(UCDim, L, dL, fr4_thickness, eps_FR4, tand);

