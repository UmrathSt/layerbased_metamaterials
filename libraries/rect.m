function rect(UCDim, fr4_thickness, L, slitN, slitL, slitW, eps_subs, tand, mesh_refinement, complemential, random);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 1;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;

  UC.nf2ff = 0;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L_' num2str(L) '_eps_' num2str(eps_subs) '_tand_' num2str(tand) '_slitN_' num2str(slitN) '_slitL_' num2str(slitL) '_slitW_' num2str(slitW) '_random_' num2str(random)];

  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'rect_slitted';
  UC.run_simulation = 1;
  UC.show_geometry = 1;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1.5e9;
  UC.f_stop = 15e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/3/mesh_refinement;
  UC.dy = UC.dx;
  UC.dump_frequencies = linspace(5,15,41)*1e9;
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-3;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  display(UC.SimPath);
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
    end;
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
  substrate.zrefinement = 5;
  


  % circle
  rect.name = 'rectangles';
  rect.lz = 0.05;
  rect.rotate = 0;
  rect.material.name = 'rectangles';
  rect.material.Kappa = 56e6;
  rect.material.type = 'const';
  rect.bmaterial.name = 'air';
  rect.bmaterial.type = 'const';
  rect.bmaterial.Epsilon = 1;
  rect.zrefinement = 3;
  rect.do_it_randomly = random;

  rect.lx = L;
  rect.ly = L;
  rect.slitL = slitL; % length of the slits (into the recangle)
  rect.slitW = slitW; % width of the slits
  rect.slitN = slitN; % number of slits along each edge of the rect

  rect.UClx = UCDim;
  rect.UCly = UCDim;
  rect.gap2_op = -1;
  rect.prio = 2;
  rect.xycenter = [0, 0];
  rect.complemential = complemential;
  
  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateSlittedRect, rect;
                                 };
  material_list = {substrate.material, rectangle.material, rect.material, rect.bmaterial};
  [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
  
  [CSX, port] = definePorts(CSX, mesh, UC.f_start);

  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    openEMS_opts = '--engine=multithreaded --numThreads=2';%'-vvv';
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
