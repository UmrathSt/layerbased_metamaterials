addpath('libraries');
addpath('./python_scripts');
clear;


UCDim =14.25;
lz = 3.2;
kappa = 56e6;
% create a polygon
rotation = inline ("round([[cos(x)*100, -sin(x)*100];[sin(x)*100,cos(x)*100]])/100");
cpunkte{1} = [[]];
folder = 'XBand_Polygon';
L1 = 4;
L2 = 3;
L3 = 1.1;
g = 0.6;
rho = 2.5;
T = 1/sqrt(2)*(L1+g);
Ti = 1/sqrt(2)*L1;
T1 = [T;0]; % translation for the first quardant of the unit cell
T2 = rotation(pi/2)*T1;
T3 = rotation(pi)*T1;
T4 = rotation(3*pi/2)*T1;
RL = g;
Rw = 0.5;
flat_rect = [[-L1/2;-L1/2], [L2-L1/2;-L1/2], [L1/2;-L2+L1/2],[L1/2;L1/2],[-L1/2;L1/2]];
irect = [[-(L1-L2);0],[0;-(L1-L2)],[L1-L2;0],[0;L1-L2]];
resistor = [[-RL/2;-Rw/2],[RL/2;-Rw/2],[RL/2;Rw/2],[-RL/2;Rw/2]];
rho1 = (L1-L2)*sqrt(2)*0.5+RL/2;

polys{1} = rotation(5*pi/4)*flat_rect+T1;
polys{2} = rotation(-pi/4)*flat_rect+T2;
polys{3} = rotation(pi/4)*flat_rect+T3;
polys{4} = rotation(-5*pi/4)*flat_rect+T4;
polys{5} = rotation(pi/4)*irect;
%polys{6} = resistor+rho1*[1;0];
%polys{7} = rotation(pi/2)*polys{6};
%polys{8} = rotation(pi)*polys{6};
%polys{9} = rotation(3*pi/2)*polys{6};
%polys{10} = rotation(-pi/4)*resistor+rho*[1;1]/sqrt(2);
%polys{11} = rotation(pi/2)*polys{10};
%polys{12} = rotation(pi)*polys{10};
%polys{13} = rotation(3*pi/2)*polys{10};

add_mesh_lines.x = [];
add_mesh_lines.y = [];
npolygon(UCDim, folder, ['withoutConnectionUCDim_' num2str(UCDim) '_lz_' num2str(lz)],...
         lz, polys, cpunkte, add_mesh_lines, 56e6, 4.6, 0.1, 0)

         