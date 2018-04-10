% Script for the extraction of effective constitutive material parameters 
% from S-Parameters according to:
% Extraction of Material Parameters for Metamaterials Using a Full-Wave Simulator
% IEEE Antennas and Propagation Magazine ( Volume: 55, Issue: 5, Oct. 2013 
% Page(s): 202 - 211
% https://ieeexplore.ieee.org/document/6735515/
clc;
clear;
% Load an example file holding frequency information and the 
% S-parameters as real and imaginary parts
% f, Re(S11), Im(S11), Re(S21), Im(S21)
S = load(['/home/stefan/Arbeit/openEMS/git_layerbased/'...
               'layerbased_metamaterials/Ergebnisse/SParameters/double_ring_trans/S11_f_UCDim_20_lz_1_R1_9.8_w1_1.5_R2_5.1_w2_0.5_eps_4.4_tand_0.015.txt']);
               
% complex S-Parameters
f = S(:,1);
s11 = S(:,2)+S(:,3)*1j;
s21 = S(:,4)+S(:,5)*1j;
c = 3e8;
k = 2*pi*f/c;
d = 1e-3;
z = ((((1+s11).^2)-s21.^2)./(((1-s11).^2)-s21.^2)).^0.5;
tmp = (z-1)./(z+1);
exp = s21./(1-s11.*tmp);
n = imag(log(exp))-1j.*real(log(exp))./(k*d);
eps_eff = n./z;
mue_eff = n.*z;
plot(f, real(eps_eff), '--b', f, imag(eps_eff), '--r');
legend('Re(\epsilon)', 'Im(\epsilon)');
xlabel('Frequency [GHz]');
ylabel('Permittivity');
drawnow;
figure;
plot(f, real(mue_eff), '--b', f, imag(mue_eff), '--r');
legend('Re(\mu)', 'Im(\mu)');
xlabel('Frequency [GHz]');
ylabel('Permeability');
drawnow;