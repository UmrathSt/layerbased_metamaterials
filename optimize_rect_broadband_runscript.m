clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

% the search vector will be [w1, R2, w2]


maxiter = 40;
global Giter = 0;
global my_eps = 1e-4;
% define fixed parameters of the double ring geometry
% which shall not be optimized

UCDim = 6;
fr4_thickness = 1.6;
eps_subs = 4.4;
tand = 0.02;
mesh_refinement = 3;
complemential = 0;
L1 = 4.7;
L2 = 1.9;
w1 = 0.6;
gap = 0.3;
fcenter = [10e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [4e9];    % the center frequency
tol = 0.05; % the maximum/minimum value of phi is 1/0  
% L1, w1, L2
x0 = [L1, w1, L2];
lb = [L1-0.1, w1-0.1, L2-0.1];
ub = [L1+0.1, w1+0.1, L2+0.1];
phi = @(x) rect_broadband_optimize(UCDim, fr4_thickness, x(1), x(2), x(3),...
     gap, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);