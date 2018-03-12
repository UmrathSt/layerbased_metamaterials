clear;
clc;
physical_constants;
addpath('./libraries');
addpath('./libraries/optimize');

% the search vector will be [w1, R2, w2]


maxiter = 100;
global Giter = 0;
global my_eps = 5e-2;
% define fixed parameters of the double ring geometry
% which shall not be optimized

UCDim = 5;
fr4_thickness = 0.6;
rubber_thickness = 1;
eps_subs = 4.4;
tand = 0.02;
mesh_refinement = 4;
complemential = 0;
L1 = 4.7;
L2 = 2.5;
L3 = 0.75;
w1 = 0.4;
w2 = 0.4;
gap = 0.3;
fcenter = [10e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [6e9];    % the center frequency
tol = 0.05; % the maximum/minimum value of phi is 1/0  
% L1, w1, L2
x0 = [L1, w1, L2, w2, L3];
lb = [L1-1, w1-0.25, L2-1, w2-0.25, L3-0.5];
ub = [L1+1, w1+0.25, L2+1, w2+0.25, L3+0.5];
% -> L1 in [4.55 .. 4.85]
% -> L2 in [1.77 .. 2.07]
% -> w1 in [0.35 .. 0.75]
% (UCDim, fr4_thickness, rubber_thickness, ...
%     L1, w1, L2, w2, L3, ...
%     gap, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
phi = @(x) drect_broadband_rubber_optimize(UCDim, fr4_thickness, rubber_thickness, ...
     x(1), x(2), x(3), x(4), x(5),...
     gap, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);