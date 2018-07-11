clear;
clc;
physical_constants;
addpath('./libraries');

UCDim = 20;
L = [18,18,1];
complemential = 0;
Epsilon = 10;
Kappa = 2*pi*5e9*EPS0*0.01;
EpsilonB = 4;
KappaB = 0;
for Kappa = [10, 100];
    cube3d(UCDim, L, Epsilon, Kappa, EpsilonB, KappaB, complemential);
end;
