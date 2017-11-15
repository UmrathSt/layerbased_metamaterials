function criss_cross(UCDim, fr4_thickness, eps_FR4, tand, complemential);
  physical_constants;
  UC.layer_td = 1;
  UC.layer_fd = 1;
  UC.td_dumps = 1;
  UC.fd_dumps = 1;
  UC.s_dumps = 1;
  UC.s_dumps_folder = '/home/stefan/Arbeit/openEMS/layerbased_metamaterials/SParameters';
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness)  '_epsFR4_' num2str(eps_FR4) '_tand_' num2str(tand)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'criss_cross';
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1e9;
  UC.f_stop = 20e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/2;
  UC.dy = UC.dz/2;
  UC.dump_frequencies = [2.4e9, 5.2e9, 16.5e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 5e-4;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  UC.SimCSX = 'geometry.xml';
  [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
  [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
  FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
  BC = {'PMC', 'PMC', 'PEC', 'PEC', 'PML_8', 'PML_8'}; % boundary conditions
  FDTD = SetBoundaryCond(FDTD, BC);

  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 0.5;
  rectangle.translate = [0, 0, 0];
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
  %rectangle.material.Kappa = 56e6;
  rectangle.material.type = 'const';
  rectangle.material.EpsilonPlasmaFrequency = 2.5e14;
  rectangle.material.EpsilonRelaxTime = 1.6e-13;
  rectangle.material.Kappa = 56e6;
  % Substrate
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = 'FR4';
  substrate.material.Epsilon = eps_FR4;
  substrate.material.tand = tand;
  substrate.material.f0 = 5e9;
  substrate.material.type = 'const';
  % circle

  crisscross.lz = 0.05;
  crisscross.translate = [0, 0, 0];
  crisscross.rotate = 0;
  crisscross.material.name = 'copperRings';
%  dblring.material.Kappa = 56e6;
  crisscross.material.EpsilonPlasmaFrequency = 2.5e14;
  crisscross.material.EpsilonRelaxTime = 1.6e-13;
  crisscross.material.Kappa = 56e6;
  crisscross.material.type = 'const';
  crisscross.bmaterial.name = 'air';
  crisscross.bmaterial.type = 'const';
  crisscross.bmaterial.Epsilon = 1;

  crisscross.UClx = UCDim;
  crisscross.UCly = UCDim;
  crisscross.prio = 2;
  crisscross.xycenter = [0, 0];
  crisscross.complemential = complemential;


  layer_list = {@CreateUC, UC; @CreateRect, rectangle; 
                               @CreateRect, substrate;
                               @CreateCrissCross, crisscross};
  material_list = {substrate.material, rectangle.material, crisscross.material, crisscross.bmaterial};
  [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
  [CSX, port] = definePorts(CSX, mesh, UC.f_start);
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    openEMS_opts = '';
    %Settings = ['--debug-PEC', '--debug-material'];
    Settings = [];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
end