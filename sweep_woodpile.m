clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 12;
w = 5;
z = 0.1;
l_subs = 2;
params = {w/2, w/2, l_subs, 'ConductingFilament', 1, 100, 'FR4', 4.6, 0.1;
                   w,UCDim,z,            'Cu', 1, 56e6, 'air', 1, 0};
complemential = 0;

woodpile('1', UCDim, params, complemential);

