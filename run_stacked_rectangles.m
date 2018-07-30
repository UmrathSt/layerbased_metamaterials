clear;
clc;
addpath('./libraries');
addpath('./python_scripts');



UCDim = 10;
kappa = 56e6;
% create a polygon
rotation = inline ("round([[cos(x)*100, -sin(x)*100];[sin(x)*100,cos(x)*100]])/100");
cpunkte{1} = [[]];

w1 = 0.5;
L2 = 4;
L1 = 7;
for N = [3,5,7,9,11];
edge_lengths = linspace(L1, L2, N);

lz = linspace(0.5,0.2,N);
stacked_rects(UCDim, ['UCDim_' num2str(UCDim) '_N_' num2str(length(edge_lengths)) '_L1_' num2str(L1) '_L2_' num2str(L2) '_lz_' num2str(sum(lz))],...
         lz, edge_lengths, 56e6, 4.6, 0.1, 0);
end;