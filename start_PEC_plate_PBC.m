clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;
scale = 1;
R1 = 9.8;
R2 = 5.1;
w1 = 1.5;
w2 = 0.5;

UCDim = 40;
complemential = 0;
fr4_thickness = 2;

tand = 0.015;
mesh_refinement = 1;
swap = 1;
eps_subs = 4.1;
% Einfallswinkel der Welle
phi_xy = 0; % -> xz-Ebene
theta_z = 0*pi/180; % -> 20 Grad mit der z-Achse
% ---------------------------
polarization.name = 'TE';
polarization.angle = pi/2; % angle phi in the xy-plane -> for pi/2: E = E * e_y

  PEC_Plate_PBC(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, tand,...
      polarization, phi_xy, theta_z, mesh_refinement, complemential);
