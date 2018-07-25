addpath('libraries');
addpath('../python_scripts');
clear;


UCDim =9;
lz = 2.7;
kappa = 56e6;
% create a polygon


rotation = inline ("round([[cos(x)*100, -sin(x)*100];[sin(x)*100,cos(x)*100]])/100");
L = 4.55;
W = 0.5;
L1 = 4.4;
W1 = 0.3;
L2 = 0.8;
W2 = 0.4;
p = 3.6;
q = 3.5;
s = 0.4;
g = 0.27;
r = 0.25;
w = 0.3;
d = 0.3;

Ihstruct = [[-p/2;-w/2],[p/2;-w/2],[p/2;w/2],[-p/2;w/2]];
Iwstruct = [[-W/2;-L/2],[W/2;-L/2],[W/2;L/2],[-W/2;L/2]];
Lstruct = [[-q/2;-g/2],[q/2;-g/2],[q/2;g/2+L1],[q/2-W1;g/2+L1],...
                  [q/2-W1;g/2],[-q/2+W2;g/2],[-q/2+W2;g/2+L2],...
                  [-q/2;g/2+L2]];
TL = [-W/2-s-q/2;-UCDim/2+d+w+r+g/2];            
Th = [TL(1);-UCDim/2+d+w/2];

punkte{1} = Iwstruct;
punkte{2} = Lstruct + TL;
punkte{3} = Ihstruct + Th;
punkte{4} = Ihstruct - Th;
punkte{5} = rotation(pi)*Lstruct - TL;


cpunkte{1} =[[]];
add_mesh_lines.x = [];
add_mesh_lines.y = [];
polygon(UCDim, ['BB_UCDim_' num2str(UCDim) '_lz_' num2str(lz)],...
         lz, punkte, cpunkte, add_mesh_lines, 56e6, 4.6, 0.1, 0)
