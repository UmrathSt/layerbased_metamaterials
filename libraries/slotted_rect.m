function slotted_rect(UCDim, fr4_thickness, L1, gap, w, eps_FR4, complemential);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 1;
  UC.td_dumps = 0;
  UC.fd_dumps = 1;
  UC.s_dumps = 1;
  UC.s_dumps_folder = '~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['absorber_UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L1_' num2str(L1) '_gap_' num2str(gap) '_w_' num2str(w) '_epsFR4_Lorentz_' num2str(eps_FR4)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'slotted_rect';
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 2e6;
  UC.f_stop = 10e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/6;
  UC.dy = UC.dx;
  UC.dump_frequencies = [1.5e9, 2.8e9, 3.7e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 5e-6;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  try;
    if strcmp(uname.nodename, 'Xeon');
        display('Running on Xeon');
        UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
        UC.s_dumps_folder = '~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters';
        UC.ResultPath = ['~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse'];
        end;
    catch lasterror;
  end;
  UC.SimCSX = 'geometry.xml';
  if UC.run_simulation;
    try;
    confirm_recursive_rmdir(0);
    catch lasterror;
    end_try_catch;
    [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
    [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  end;
  FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
  FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
  BC = {'PMC', 'PMC', 'PEC', 'PEC', 'PML_8', 'PML_8'}; % boundary conditions
  FDTD = SetBoundaryCond(FDTD, BC);
  rectangle.name = 'backplate';
  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 0.5;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
  #rectangle.material.Kappa = 56e6;
  rectangle.material.type = 'const';

  rectangle.material.Kappa = 56e6;
  slotted_rect.name = 'squares';
  slotted_rect.L1 = L1; 
  slotted_rect.gap = gap;
  slotted_rect.w = w; 

  slotted_rect.lz = 0.05;
  slotted_rect.rotate = 0;
  slotted_rect.prio = 2;
  slotted_rect.xycenter = [0, 0];
  slotted_rect.material.name = 'copperSquares';
  slotted_rect.material.type = 'const';
  slotted_rect.material.Kappa = 56e6;
  slotted_rect.bmaterial.name = 'air';
  slotted_rect.bmaterial.type = 'const';
  slotted_rect.bmaterial.Epsilon = 1;
  

  # Substrate
  substrate.name = 'FR4 substrate';
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = 'FR4';
  substrate.material.Epsilon = eps_FR4;
  substrate.material.Kappa = 2*pi*5e9*EPS0*0.02*4.4;
  substrate.material.type = 'const';
  substrate.material.f0 = 5e9;




  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateSlottedRect, slotted_rect;
                                 };
  material_list = {slotted_rect.material, slotted_rect.bmaterial, rectangle.material, substrate.material};
  [CSX, mesh, param_str, UC] = stack_layers(layer_list, material_list);
  [CSX, port, UC] = definePorts(CSX, mesh, UC);
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    openEMS_opts = '--numThreads=6';#'-vvv';
    #Settings = ['--debug-PEC', '--debug-material'];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
end