clear;
clc;
physical_constants;
addpath('./libraries');

scale = 1; % 0.3
UCDim = 14.5; % 14.5
complemential = 0;
fr4_thickness = 2;

eps_FR4 = 4.1;
for kappaS = [1000, 1250, 1500];
    criss_cross(scale, UCDim, fr4_thickness, eps_FR4, kappaS, complemential)
end;
