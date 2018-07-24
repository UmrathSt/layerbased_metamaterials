function random_fss(UCDim, fr4_thickness, filling, eps_subs, tand, complemential);
  % Create an fss on top of a substrate
  % which as a given filling factor of random rectangles
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 1;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;

  UC.nf2ff = 0;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_filling_' num2str(filling) '_eps_' num2str(eps_subs) '_tand_' num2str(tand)];

  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'random_filling';
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 2e9;
  UC.f_stop = 15e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  DX = UC.dz
  UC.dx = UC.dz/3;
  UC.dy = UC.dx;
  UC.dump_frequencies = linspace(5,15,41)*1e9;
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-4;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  display(UC.SimPath);
  UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  try;
    if strcmp(uname.nodename, 'Xeon');
        display('Running on Xeon');
        UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
        UC.s_dumps_folder = '~/Arbeit/openEMS/development/layerbased_metamaterials/Ergebnisse/SParameters';
        UC.ResultPath = ['~/Arbeit/openEMS/development/layerbased_metamaterials/Ergebnisse'];
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
  random_rect.name = 'random rectangles';
  random_rect.lz = 0.1;
  random_rect.rotate = 0;
  random_rect.material.name = 'rectangles';
  random_rect.material.Kappa = 56e6;
  random_rect.material.type = 'const';
  random_rect.bmaterial.name = 'air';
  random_rect.bmaterial.type = 'const';
  random_rect.bmaterial.Epsilon = 1;
  random_rect.zrefinement = 3;
  random_rect.UClx = UCDim;
  random_rect.UCly = UCDim;
  random_rect.L = DX;
  % choose the center positions according to the filling factor
  random_rect.N = round(UC.lx*UC.ly/(DX**2)*filling);
  random_rect.centers = GenerateRandomPoints(random_rect.N,-UC.lx/2+DX/2, UC.lx/2-DX/2, -UC.ly/2+DX/2, UC.ly/2-DX/2, DX, DX);
  random_rect.prio = 2;
  random_rect.xycenter = [0, 0];
  random_rect.complemential = complemential;
  
  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate
                               @CreateRandomRects, random_rect;
                                 };
  [CSX, mesh, param_str, UC] = stack_layers(layer_list);
  [CSX, port, UC] = definePorts(CSX, mesh, UC);
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
    fprintf(['\nTrying to write simulation data to: ', UC.SimPath '/' UC.SimCSX '\n']);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    npc = 2;
    if strcmp(uname.nodename, 'Xeon');
        npc = 6;
    end;
    
    openEMS_opts = ['--engine=multithreaded --numThreads=' num2str(npc)];%'-vvv';
    #Settings = ['--debug-PEC', '--debug-material'];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
end
