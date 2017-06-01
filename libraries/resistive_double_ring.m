function resistive_double_ring(UCDim, fr4_thickness, R1, w1, R2, w2, eps_FR4, complemential);
  physical_constants;
  UC.layer_td = 1;
  UC.layer_fd = 1;
  UC.td_dumps = 1;
  UC.fd_dumps = 1;
  UC.s_dumps = 1;
  UC.s_dumps_folder = "/home/stefan/Arbeit/openEMS/layerbased_metamaterials/SParameters";
  UC.s11_filename_prefix = ["UCDim_" num2str(UCDim) "_lz_" num2str(fr4_thickness) "_R1_" num2str(R1) "_w1_" num2str(w1) "_R2_" num2str(R2) "_w2_" num2str(w2) "_epsFR4_Lorentz_" num2str(eps_FR4)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, "_comp");
  endif;
  UC.s11_filename = "Sparameters_";
  UC.s11_subfolder = "resistive_double_ring";
  UC.run_simulation = 1;
  UC.show_geometry = 1;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1e9;
  UC.f_stop = 20e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/3;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9, 16.5e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 5e-4;
  UC.SimPath = ["/mnt/hgfs/E/openEMS/layerbased_metamaterials/" UC.s11_subfolder "/" UC.s11_filename_prefix];
  confirm_recursive_rmdir(0);
  UC.SimCSX = "geometry.xml";
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
  rectangle.material.name = "copper";
  #rectangle.material.Kappa = 56e6;
  rectangle.material.type = "const";
  rectangle.material.EpsilonPlasmaFrequency = 2.5e14;
  rectangle.material.EpsilonRelaxTime = 1.6e-13;
  rectangle.material.Kappa = 56e6;
  # Substrate
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = "FR4_Lorentz";
  substrate.material.Epsilon = eps_FR4;

  # circle

  dblring.lz = 0.05;
  dblring.translate = [0, 0, 0];
  dblring.rotate = 0;
  dblring.material.name = "copperRings";
#  dblring.material.Kappa = 56e6;
  dblring.material.EpsilonPlasmaFrequency = 2.5e14;
  dblring.material.EpsilonRelaxTime = 1.6e-13;
  dblring.material.Kappa = 56e6;
  dblring.material.type = "const";
  dblring.bmaterial.name = "air";
  dblring.bmaterial.type = "const";
  dblring.bmaterial.Epsilon = 1;
  dblring.R1 = R1;
  dblring.R2 = R2;
  dblring.w1 = w1;
  dblring.w2 = w2;
  dblring.UClx = UCDim;
  dblring.UCly = UCDim;
  dblring.prio = 2;
  dblring.xycenter = [0, 0];
  dblring.complemential = complemential;
  dblring.Resistance = 10; # coupling resistance to neighbouring cell
  dblring.ResWidth = 0.5;


  layer_list = {@CreateUC, UC; @CreateRect, rectangle; 
                               @CreateRect, substrate;
                               @CreateResistiveDoubleRing, dblring};
  material_list = {substrate.material, rectangle.material, dblring.material, dblring.bmaterial};
  [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
  [CSX, port] = definePorts(CSX, mesh, UC.f_start);
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  endif;
  if UC.run_simulation;
    openEMS_opts = '';#'-vvv';
    #Settings = ["--debug-PEC", "--debug-material"];
    Settings = [];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  endif;
  doPortDump(port, UC);
endfunction;