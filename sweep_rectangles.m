clear;
clc;
physical_constants;
addpath("./libraries");


UCDim = 20;
complemential = 0;
eps_FR4 = 4.15;
tand = 0.015;
number = 10;
fr4_thickness = 0.2;
L = 18;
dL = 1;
N = 20;

rectangles(UCDim, fr4_thickness, N, L, dL, eps_FR4, tand, complemential);

