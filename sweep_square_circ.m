clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 10;
fr4_thickness = 0.4;
L1 = 9.5;
R1 = 3.35;
eps_FR4 = 4.4;
complemential = 0;

square_circ(UCDim, fr4_thickness, L1, R1, eps_FR4, complemential);