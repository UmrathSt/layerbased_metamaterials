function val = optimize_rect_broadband_chipres2(UCDim, fr4_thickness, L1, L2, rho, gapwidth, ...
gapwidth2, reswidth, Res1, Res2, eps_subs, tand, mesh_refinement, complemential, fcenter, fwidth);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.nf2ff = 0;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['meta_UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L1_' num2str(L1) '_L2_' num2str(L2) '_rho_' num2str(rho) '_gapw1_' num2str(gapwidth) '_gapw2_' num2str(gapwidth2) '_resw_' num2str(reswidth) '_Res1_' num2str(Res1) '_Res2_' num2str(Res2)  '_eps_' num2str(eps_subs) '_tand_' num2str(tand)];
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'rect_broadband_chipres2';
  UC.run_simulation = 1;
  UC.show_geometry = 0
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 3.0e9;
  UC.f_stop = 15e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/3/mesh_refinement;
  UC.dy = UC.dx;
  UC.dump_frequencies = linspace(4,14,101)*1e9;
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-5;
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
  rectangle.name = 'groundplane';
  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 0.5;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
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
  substrate.material.Kappa = 2*pi*12e9*EPS0*tand*eps_subs;
  substrate.zrefinement = 1;


  % chipres
  chipres.name = 'rectangles';
  chipres.lz = 0.1;
  chipres.prio = substrate.prio+1;
  chipres.rotate = pi/4;
  chipres.sheet_thickness = 18e-3; % 18 Microns
  chipres.material.name = 'rectangles_sheet';
  %substrate.zrefinement = 5;


  chipres.material.Kappa = 56e6;
  chipres.material.type = 'sheet';
  chipres.material.D = chipres.sheet_thickness;
  chipres.bmaterial.name = 'air';
  chipres.bmaterial.type = 'const';
  chipres.bmaterial.Epsilon = 1;
  chipres.dphi = 0;
  chipres.Resistor1.name = 'chipresistor1';
  chipres.RL = 0.0; % additional small pad island narrowing the gap left and 
  chipres.Resistor1.Kappa = gapwidth/(Res1*reswidth*chipres.lz*UC.unit);
  chipres.Resistor1.sheet_thickness = chipres.sheet_thickness;
  chipres.Resistor1.Epsilon = 1;
  chipres.Resistor1.type = 'const';
  chipres.Resistor1.Epsilon = 1;
  chipres.Resistor2.name = 'chipresistor2';
  chipres.Resistor2.Kappa = gapwidth/(Res2*reswidth*chipres.lz*UC.unit);
  chipres.Resistor2.sheet_thickness = chipres.sheet_thickness;
  chipres.Resistor2.Epsilon = 1;
  chipres.Resistor2.type = 'const';

  chipres.L1 = L1;
  chipres.L2 = L2;

  chipres.rho = rho;
  chipres.gapwidth = gapwidth;
  chipres.gapwidth2 = gapwidth2;
  chipres.reswidth = reswidth;
  chipres.Res1 = Res1; % right to the resistors
  chipres.Res2 = Res2;
  chipres.UClx = UCDim;
  chipres.UCly = UCDim;
  chipres.prio = 4;
  chipres.xycenter = [0, 0];
  chipres.do_xy_meshing = 1;
  chipres.complemential = complemential;
  chipres.zrefinement = 1;
  
  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateRectBroadbandChipres2, chipres
                                 };

  material_list = {rectangle.material,substrate.material, chipres.material, chipres.bmaterial, chipres.Resistor1, chipres.Resistor2};
  [CSX, mesh, param_str, UC] = stack_layers(layer_list, material_list);
  
  [CSX, port, UC] = definePorts(CSX, mesh, UC);

  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    num_threads = 4;
    try;
      if strcmp(uname.nodename, 'Xeon');
        num_threads = 6;
      end;
    catch lasterror;
    end;
    openEMS_opts = ['--engine=multithreaded --numThreads=' num2str(num_threads)];%'-vvv';
    %Settings = ['--debug-PEC', '--debug-material'];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;

  val = doPortDump_optimize(port, UC, fcenter, fwidth);
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
