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

UCDim = 14.25;
fr4_thickness = 3.2;
eps_subs = 4.6;
tand = 0.02;
mesh_refinement = 2;
complemential = 0;
L1 = 4;
L2 = 2.5;
R1 = 300;
R2 = 30;

rho = 2.5;
reswidth = 0.5;
gapwidth = 0.6;
fcenter = [10e9]; % try to minimize abs(S11) in an interval of +-fwidth/2 around
fwidth = [5.4e9];    % the center frequency
tol = 0.5; % the maximum/minimum value of phi is 1/0  
% L1, w1, L2
x0 = [1, 1];
lb = [0.1, 0.1];
ub = [10, 10];
% -> L1 in [4.55 .. 4.85]
% -> L2 in [1.77 .. 2.07]
% -> w1 in [0.35 .. 0.75]
phi = @(x) OPTimize_rect_broadband_chipres2(UCDim, fr4_thickness, L1, L2, rho,...
     gapwidth, gapwidth, reswidth, R1*x(1), R2*x(2), eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
[x, obj, info, iter, nf, lambda] = my_sqp (x0, phi, [], [], lb, ub, maxiter);