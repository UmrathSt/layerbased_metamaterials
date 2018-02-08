clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

% the search vector will be [w1, R2, w2]

x0 = [1.5, 7.5, 1];
lb = [0.5, 3, 0.25];
ub = [4, 7, 3];
maxiter = 40;
global Giter = 0;
global my_eps = 1e-5;
% define fixed parameters of the double ring geometry
% which shall not be optimized

UCDim = 20;
fr4_thickness = 2;
eps_subs = 4.15;
tand = 0.015;
mesh_refinement = 1.5;
complemential = 0;
R1 = 9.8;

fcenter = [7.5e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [4e9];    % the center frequency
tol = 0.05; % the maximum/minimum value of phi is 1/0  
phi = @(x) rect_broadband_optimize(R1, x(1), x(2), x(3), UCDim, fr4_thickness, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);