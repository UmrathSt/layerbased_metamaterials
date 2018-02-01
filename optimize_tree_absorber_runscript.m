clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

% the search vector will be [w1, R2, w2]

x0 = [6, 10];
lb = [5, 9];
ub = [7, 11];

global Giter = 0;
global my_eps = 1e-5;
% define fixed parameters of the double ring geometry
% which shall not be optimized

maxiter = 40;
UCDim = 12;
fr4_thickness = 2;
eps_subs = 4.15;
tand = 0.015;
mesh_refinement = 2;
complemential = 0;
R = 0.3;
w = 0.5
Resistance = 220;

fcenter = [10e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [9e9];    % the center frequency
tol = 0.01; % the maximum/minimum value of phi is 1/0  
phi = @(x) optimize_tree_absorber(UCDim, fr4_thickness, R, 0, w, x(1), x(2), Resistance, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);