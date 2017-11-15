clear;
clc;
physical_constants;
addpath("./libraries");

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 5.1;
w1 = 1.5;
w2 = 0.5;

UCDim = 20;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = 2;
swap = 0;
eps_subs = 4.1;
 
criss_cross(UCDim, fr4_thickness, eps_subs, tand, mesh_refinement, complemential);
