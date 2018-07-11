function rect_broadband(UCDim, fr4_thickness, L1, w1, L2, gap, eps_subs, Rsq, tand, tand2, flat, mesh_refinement, complemential);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.nf2ff = 0;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L1_' num2str(L1) '_w_' num2str(w1) '_L2_' num2str(L2) '_gap_' num2str(gap) '_eps_' num2str(eps_subs) '_Rsq_' num2str(Rsq) '_tand_' num2str(tand) '_tand2_' num2str(tand2) '_flat_' num2str(flat)];
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'broadband_rect';
  UC.run_simulation = 1;
  UC.show_geometry = 1;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 3e9;
  UC.f_stop = 15e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/3/mesh_refinement;
  UC.dy = UC.dx;
  UC.dump_frequencies = linspace(5,15,41)*1e9;
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-4;
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
  substrate.material.f0 = 10e9;
  substrate.zrefinement = 3;
 % substrate 2
  substrate2.name = 'FR4 substrate2';
  substrate2.lx = UC.lx;
  substrate2.ly = UC.ly;
  substrate2.lz = fr4_thickness;
  substrate2.rotate = 0;
  substrate2.prio = 2;
  substrate2.xycenter = [0, 0];
  substrate2.material.name = 'Dielectric2';
  substrate2.material.type = 'const';
  substrate2.material.Epsilon = eps_subs;
  substrate2.material.tand = tand2;
  substrate2.material.f0 = 10e9;
  substrate2.zrefinement = 3;


  % circle
  rect.name = 'rectangles';
  rect.lz = 0.05;
  rect.rotate = 0;
  rect.material.name = 'rectangles';
  rect.material.Kappa = 1/(Rsq*rect.lz*UC.unit);
  rect.material.type = 'const';
  rect.bmaterial.name = 'FR4';
  rect.zrefinement = 3;
  rect.flat = flat;
  rect.L1 = L1;
  rect.L2 = L2;
  rect.w1 = w1;
  rect.gap = gap;
  rect.UClx = UCDim;
  rect.UCly = UCDim;
  rect.prio = 6;
  rect.xycenter = [0, 0];
  rect.complemential = complemential;
  % second rectangle
    % circle
  rec1t.name = 'rectangles2';
  rect1.lz = 0.05;
  rect1.rotate = 0;
  rect1.material.name = 'rectangles';
  rect1.material.Kappa = 1/(Rsq*rect.lz*UC.unit);
  rect1.material.type = 'const';
  rect1.bmaterial.name = 'air';
  rect1.bmaterial.type = 'const';
  rect1.bmaterial.Epsilon = 1;
  rect1.zrefinement = 3;
  rect1.flat = flat;
  rect1.L1 = L1*1.05;
  rect1.L2 = L2*1.05;
  rect1.w1 = w1*1.05;
  rect1.gap = gap;
  rect1.UClx = UCDim;
  rect1.UCly = UCDim;
  rect1.prio = 6;
  rect1.xycenter = [0, 0];
  rect1.complemential = complemential;
  
  
  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateBroadbandFlatRect, rect;
                               @CreateRect, substrate2;
                               @CreateBroadbandFlatRect, rect1;
                                 };
  material_list = {substrate.material, substrate2.material, rectangle.material, rect.material, rect1.bmaterial};
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