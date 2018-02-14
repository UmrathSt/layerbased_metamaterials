clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

% the search vector will be [w1, R2, w2]


maxiter = 100;
global Giter = 0;
global my_eps = 1e-2;
% define fixed parameters of the double ring geometry
% which shall not be optimized

UCDim = 7;
fr4_thickness = 1;
rubber_thickness = 1;
eps_subs = 4.4;
tand = 0.02;
mesh_refinement = 3;
complemential = 0;
L1 = 4.9;
L2 = 1.9;
w1 = 0.9;
gap = 0.6;
fcenter = [10e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [5.4e9];    % the center frequency
tol = 0.05; % the maximum/minimum value of phi is 1/0  
% L1, w1, L2
x0 = [rubber_thickness];
lb = [rubber_thickness-0.6];
ub = [rubber_thickness+0.6];
% -> L1 in [4.55 .. 4.85]
% -> L2 in [1.77 .. 2.07]
% -> w1 in [0.35 .. 0.75]
phi = @(x) rect_broadband_rubber_optimize(UCDim, fr4_thickness, x(1), L1, w1, L2,...
     gap, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);