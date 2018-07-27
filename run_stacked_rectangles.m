clear;
clc;
addpath('./libraries');
addpath('./python_scripts');



UCDim =9;
lz = 0.2;
kappa = 56e6;
% create a polygon
rotation = inline ("round([[cos(x)*100, -sin(x)*100];[sin(x)*100,cos(x)*100]])/100");
cpunkte{1} = [[]];
L1 = 8;
w1 = 0.5;
L2 = L1-2*w1;
Ls = 3;
Ll = 8;
N = 3;
edge_lengths = linspace(Ll, Ls, N);
lz = linspace(0.4, 0.2,N);
stacked_rects(UCDim, ['N_' num2str(length(edge_lengths)) '_L1_' num2str(Ll) '_L2_' num2str(L2) '_lz_' num2str(sum(lz))],...
         lz, edge_lengths, 56e6, 4.6, 0.1, 0);