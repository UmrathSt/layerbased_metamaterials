function [CSX, port] = definePBCPorts(CSX, mesh, f_start, f0, unit, polarization, phi_xy, theta_z)
% Define a plane wave mode profile for propagation in the direction:
% [sin(theta_z)*cos(phi_xy), sin(theta_z)*sin(phi_xy), cos(theta_z)]
% with either E or H in the xy-plane (TE/TM) with:
% E/H = [cos(gamma),sin(gamma), 0]
% where gamma is given as: polarization.angle
% and polarization.name = 'TE'/'TM'
  physical_constants;
  n_cells_to_edge = 20;
  p1 = [mesh.x(1), mesh.y(1), mesh.z(n_cells_to_edge)];
  lambda_max = C0/f_start;
  k0 = 2*pi*f0/c0;
  p2 = [mesh.x(end), mesh.y(end), mesh.z(n_cells_to_edge+5)]; % excitation is 5 cells from measurment plane
  p3 = p1;
  p4 = [mesh.x(end), mesh.y(end), mesh.z(end-n_cells_to_edge)];
  k = unit*k0*[sin(theta_z)*cos(phi_xy), sin(theta_z)*sin(phi_xy), cos(theta_z)];
  gamma = polarization.angle;
  if strcmp(polarization.name, 'TE')
    printf('TE POLARIZED PBC Excitation');
    E = [cos(gamma), sin(gamma), 0];
    func_E{1} = ['(' num2str(cos(polarization.angle)) ')*cos((' num2str(k(1)) ')*x+(' num2str(k(2)) ')*y+(' num2str(k(3)) ')*z)'];
    func_E{2} = ['(' num2str(sin(polarization.angle)) ')*cos((' num2str(k(1)) ')*x+(' num2str(k(2)) ')*y+(' num2str(k(3)) ')*z)'];
    func_E{3} = '0';
    H = cross(k, E);
    func_H{1} = ['(' num2str(H(1)) ')*cos((' num2str(k(1)) ')*x+(' num2str(k(2)) ')*y+(' num2str(k(3)) ')*z)'];
    func_H{2} = ['(' num2str(H(2)) ')*cos((' num2str(k(1)) ')*x+(' num2str(k(2)) ')*y+(' num2str(k(3)) ')*z)'];
    func_H{3} = ['(' num2str(H(3)) ')*cos((' num2str(k(1)) ')*x+(' num2str(k(2)) ')*y+(' num2str(k(3)) ')*z)'];
  elseif strcmp(polarization.name, 'TM')
    printf('TM POLARIZED PBC Excitation');
    H = [cos(polarization.angle), sin(polarization.angle), 0];
    func_H{1} = ['(' num2str(cos(polarization.angle)) ')*cos((' num2str(k(1)) ')*x)'];
    func_H{2} = ['(' num2str(sin(polarization.angle)) ')*cos((' num2str(k(2)) ')*y)'];
    func_H{3} = '0';
    E = cross(H, k);
    func_E{1} = ['-(' num2str(H(1)) ')*cos((' num2str(k(1)) ')*x)'];
    func_E{2} = ['-(' num2str(H(2)) ')*cos((' num2str(k(2)) ')*y)'];
    func_E{3} = ['-(' num2str(H(3)) ')*cos((' num2str(k(3)) ')*z)'];
  end
  [CSX, port{1}] = AddPBCWaveGuidePort(CSX, 10, 1, p1, p2, 2, func_E, func_H, 1, 1);
  [CSX, port{2}] = AddPBCWaveGuidePort(CSX, 10, 2, p3, p4, 2, func_E, func_H, 1, 0);
end