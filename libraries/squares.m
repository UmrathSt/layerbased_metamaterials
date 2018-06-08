function squares(UCDim, fr4_thickness, L1, L2, eps_FR4, Rsq, complemential);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.s_dumps_folder = '~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['absorber_UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L1_' num2str(L1) '_L2_' num2str(L2) '_Rsq_' num2str(Rsq) '_epsFR4_Lorentz_' num2str(eps_FR4)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'resistive_film_square';
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
  UC.dx = UC.dz/3;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9];
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
  squares.name = 'squares';
  squares.lx1 = L1; 
  squares.lx2 = L2; 
  squares.ly1 = L1; 
  squares.ly2 = L2; 
  squares.lz = 0.1;
  squares.rotate = 0;
  squares.prio = 6;
  squares.xycenter = [0, 0];
  squares.material.name = 'copperSquares';
  squares.material.type = 'const';
  squares.imaterial.name = "Icopper";
  squares.imaterial.type = "const";
  squares.imaterial.Kappa = 56e6;
  squares.omaterial.name = "OcopperSquares";
  squares.omaterial.type = 'const';

  squares.omaterial.Kappa =56e6;
  
# film

  film.name = 'resistive_film';
  film.lx = UCDim;
  film.ly = UCDim;
  film.lz = 0.1;
  film.rotate = 0;
  film.prio = 3;
  film.xycenter = [0, 0];
  film.material.name = 'film_material';
  film.material.Kappa = 1/(film.lz*Rsq*UC.unit);;
  film.material.type = 'const';
  film.zrefinement = 3;


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
  substrate.material.Kappa = 2*pi*10e9*EPS0*eps_FR4*0.02;
  substrate.material.type = 'const';





  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateRect, film;
                               @CreateRect, substrate;
                               @CreateSquares, squares;
                                 };
  material_list = {film.material,squares.imaterial, squares.omaterial, rectangle.material, substrate.material};
  [CSX, mesh, param_str, UC] = stack_layers(layer_list, material_list);
  [CSX, port, UC] = definePorts(CSX, mesh, UC);
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    openEMS_opts = '--numThreads=4';#'-vvv';
    #Settings = ['--debug-PEC', '--debug-material'];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
end