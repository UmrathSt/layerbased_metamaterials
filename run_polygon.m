addpath('libraries');
addpath('../python_scripts');
clear;


UCDim = 20;
lz = 2;
kappa = 56e6;
% create a polygon
rectL = 9; % half the edge-length of the copper rectangle
punkte{1} = [[-1;1],[1;1],[1;-1],[-1;-1]]*rectL;

rectangle = [[-1.5;1.5],[1.5;1.5],[1.5;-1.5],[-1.5;-1.5]].*1.25;

shift = UCDim/4;
idx = 1;
scale = ones(1,25)*0.6;
for ux = -2:2;
    for uy = -2:2;
        cpunkte{idx} = rectangle*scale(idx) + [ux;uy].*[3.5;3.5];
        idx = idx+1;
    end;
end;
   
 
polygon(UCDim, ['grid_UCDim_' num2str(UCDim) '_lz_' num2str(lz)],...
         lz, punkte, cpunkte, 56e6, 4.6, 0.1, 0)
