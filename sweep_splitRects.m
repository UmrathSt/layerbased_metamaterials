clear;
clc;
physical_constants;
addpath('./libraries');


L1 = 11*6/5;
L2 = 11*6/5;
w1 = 3*6/5;
w2 = 3*6/5; %%%%%%%%%%%
gap = 3*6/5;
UCDim = 60;
complemential = 0;
mesh_refinement = 0.5;

fr4_thickness = 2;
eps_FR4 = 4.1;
tand = 0.015;
for fr4_thickness = [1, 1.5, 2];
  for L = [11.5, 12, 12.5];
    for gap = [3.5, 4, 4.6];
      L1 = L;
      L2 = L;
      SplitRects(UCDim, fr4_thickness, L1, w1, L2, w2, gap, eps_FR4, tand, mesh_refinement, complemential);
    end;
  end;
end;


