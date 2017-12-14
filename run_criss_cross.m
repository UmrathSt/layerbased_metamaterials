clear;
clc;
physical_constants;
addpath('./libraries');

scale = 0.3;
UCDim = 14.5;
complemential = 0;
fr4_thickness = 2;

eps_FR4 = 2;
for kappaS = [450];
    criss_cross(scale, UCDim, fr4_thickness, eps_FR4, kappaS, complemential)
end;
