addpath('libraries');
addpath('../python_scripts');
clear;
N = 20;
dphi = pi/N;
phi0 = pi/2;
UCDim = 15;
R1 = 5;
R2 = 3;
R3 = 7;
% create a star
scale = 0.4;
for N = [20];
for kappa = [56e6];
for lz = [0.4];
for i = 1:2*N;
    R = R1;
    if mod(i,2);
        R = R2;
    end;
    if mod(i,3);
        R = R3;
    end;
    
    punkte(i,1) = R*cos(dphi*i);
    punkte(i,2) = R*sin(dphi*i);
    cpunkte(i,1) = R*cos(dphi*i)*scale;
    cpunkte(i,2) = R*sin(dphi*i)*scale;

end;

polygon(UCDim, ['UCDim_' num2str(UCDim) '_N_' num2str(N) '_lz_' num2str(lz) '_kappa_' num2str(kappa)],...
         lz, punkte, cpunkte, kappa, 4.6, 0.025, 0)
end;end;end;