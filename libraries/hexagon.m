function hexagon(UCly, fr4_thickness, L1, w1, eps_subs, tand, kappa, mesh_refinement, complemential);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.nf2ff = 0;
  if strcmp(uname().nodename, 'Xeon');
    midstr = '/';
    printf('Running job on XEON \n');
  else;
    midstr = '/git_layerbased/';
  endif;
  UC.s_dumps_folder = ['~/Arbeit/openEMS' midstr 'layerbased_metamaterials/Ergebnisse/SParameters'];
  UC.s11_filename_prefix = ['hexUCly_' num2str(UCly) '_lz_' num2str(fr4_thickness)  '_L_' num2str(L1) '_w_' num2str(w1) '_kappa_' num2str(kappa) '_eps_' num2str(eps_subs) '_tand_' num2str(tand)];

  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'hexagon';
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1.5e9;
  UC.f_stop = 20e9;
  UC.lx = UCly*sqrt(3);
  UC.ly = UCly;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/3/mesh_refinement;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9, 7.5e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-5;
  if strcmp(uname().nodename, 'Xeon');
    UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
    UC.ResultPath = ['~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse'];
  else;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  endif;
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
  rectangle.lx = UC.lx;
  rectangle.ly = UC.ly;
  rectangle.lz = 0.5;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
  %rectangle.material.Kappa = 56e6;
  rectangle.material.type = 'const';
  rectangle.material.Kappa = 56e6;

  % Substrate
  substrate.name = 'FR4 substrate';
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = 'FR4';
  substrate.material.type = 'const';
  substrate.material.Epsilon = eps_subs;
  substrate.material.tand = tand;
  substrate.material.f0 = 5e9;
  substrate.zrefinement = sqrt(eps_subs);

  % circle
  hexagon.name = 'Hexagon';
  hexagon.lz = 0.05;
  hexagon.rotate = 0;
  hexagon.material.name = 'CopperHexagon';
  hexagon.material.Kappa = kappa;
  hexagon.material.type = 'const';
  hexagon.bmaterial.name = 'air';
  hexagon.bmaterial.type = 'const';
  hexagon.bmaterial.Epsilon = 1;

  hexagon.Lhex1 = L1;
  hexagon.whex1 = w1;
  hexagon.UClx = UC.lx;
  hexagon.UCly = UC.ly;
  hexagon.prio = 2;
  hexagon.xycenter = [0, 0];
  hexagon.complemential = complemential;
  
  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateHEXagon, hexagon;
                                 };
  material_list = {substrate.material, rectangle.material, hexagon.material, hexagon.bmaterial};
  [CSX, mesh, param_str, UC] = stack_layers(layer_list, material_list);
  
  [CSX, port, UC] = definePorts(CSX, mesh, UC);

  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    openEMS_opts = '--engine=multithreaded --numThreads=4';%'-vvv';
    %Settings = ['--debug-PEC', '--debug-material'];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
  if UC.nf2ff == 1;
    freq = [2.4e9, 5.2e9, 12e9, 15e9];
    phi = linspace(0, 2*pi, 100);
    theta = linspace(0, pi, 100);
    for f0 = freq;
      printf(['calculating 3D far field for f=' num2str(f0) '\n']);
      printf(['Using phase center x=0, y=0, z=' num2str(phase_center_z) '\n']);
      nf2ff = CalcNF2FF(nf2ff, UC.SimPath, f0, theta, phi, 'Mode', UC.run_simulation, 'Center', [0, 0, phase_center_z*2]);
      printf(['WARNING: Shifted the phase-center by a factor of two for optical reasons \n']);
      E_far_normalized = nf2ff.E_norm{1}/max(nf2ff.E_norm{1}(:));
      DumpFF2VTK([UC.SimPath '/NF2FF_f_' num2str(f0/1e9) '_GHz.vtk'],E_far_normalized,theta*180/pi, phi*180/pi,'scale',1e-2);
      printf(['Far-field pattern for f = ' num2str(f0) ' written to *.vtk\n']);
    end;
  end;
end