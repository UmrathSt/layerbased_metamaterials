clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 12;
w = 8;
z = 0.1;
l_subs = 2;
params = {UCDim-2, UCDim-2, l_subs, 'ConductingFilament', 1.5, 5, 'air', 1, 0;
                   UCDim-2,UCDim-2,z,            'Cu', 1, 56e6, 'air', 1, 0};
complemential = 0;

woodpile('3', UCDim, params, complemential);

