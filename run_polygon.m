addpath('libraries');
addpath('../python_scripts');
clear;


UCDim =9;
lz = 0.2;
kappa = 56e6;
% create a polygon
rotation = inline ("round([[cos(x)*100, -sin(x)*100];[sin(x)*100,cos(x)*100]])/100");
cpunkte{1} = [[]];
L1 = 8;
w1 = 0.5;
L2 = L1-2*w1;

punkte{1} =[[-L1/2;-L1/2],[L1/2;-L1/2],[L1/2;L1/2],[-L1/2;L1/2]...
                      [-L1/2;-L2/2],[-L2/2;-L2/2],[-L2/2;L2/2],[L2/2;L2/2],...
                      [L2/2;-L2/2],[-L1/2;-L2/2]];
add_mesh_lines.x = [];
add_mesh_lines.y = [];
polygon(UCDim, ['openrect_UCDim_' num2str(UCDim) '_lz_' num2str(lz)],...
         lz, punkte, cpunkte, add_mesh_lines, 56e6, 4.6, 0.1, 0)
