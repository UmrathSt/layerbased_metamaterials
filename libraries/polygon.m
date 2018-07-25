function polygon(UCDim, name, fr4_thickness, points, cpoints, add_mesh_lines, kappa, epsRe, tand, complemential);
  physical_constants;
  UC.layer_td = 1;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = [name];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end;
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'polygon';
  UC.run_simulation = 1;
  UC.show_geometry = 1;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 3e9;
  UC.f_stop = 20e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 2 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/7;
  UC.dy = UC.dx;
  UC.dump_frequencies = [6.46, 8.64,9.2]*1e9;
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-4;
  UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  UC.SimCSX = 'geometry.xml';
  UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  if strcmp(uname.nodename, 'Xeon');
      UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
      UC.ResultPath = ['~/Arbeit/openEMS/development/layerbased_metamaterials/Ergebnisse'];
 end;
  
  if UC.run_simulation;
    confirm_recursive_rmdir(0);
    [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
    [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  end;
  FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
  FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
  BC = {'PMC', 'PMC', 'PEC', 'PEC','PML_8', 'PML_8'}; % boundary conditions
  FDTD = SetBoundaryCond(FDTD, BC);
  rectangle.name = 'backplate';
  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 1;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
  rectangle.material.Kappa = 56e6;
  
  # Substrate
  substrate.name = 'FR4 substrate';
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = 'FR4';
  substrate.material.Epsilon = epsRe;
  substrate.material.Kappa = 2*pi*UC.f_stop*tand*epsRe*EPS0;
  substrate.zrefinement = 3;

   polygon.name = 'Rectangle';
   polygon.lx = UC.lx;
   polygon.ly = UC.ly;
   polygon.lz = 0.05;
   polygon.pts = points;
   polygon.cpts = cpoints;
   polygon.rotate = 0;
   polygon.prio = 4;
   polygon.xycenter = [0, 0];
   polygon.material.name = 'CuRectangle';
   polygon.material.Epsilon = 1;
   polygon.material.Kappa = kappa;
   polygon.cmaterial.name = 'AirCutout';
   polygon.cmaterial.Epsilon = 1;
   polygon.cmaterial.Kappa = 1;
   polygon.zrefinement = 1;


  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreatePolygon, polygon;
                                 };
  [CSX, mesh, param_str, UC] = stack_layers(layer_list);
  mesh.x = SmoothMeshLines([mesh.x, add_mesh_lines.x],1.2);
  mesh.y = SmoothMeshLines([mesh.y, add_mesh_lines.y], 1.2);
  CSX = DefineRectGrid(CSX, UC.unit, mesh);
  [CSX, port, UC] = definePorts(CSX, mesh, UC, 'y');
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  fprintf(['\nTrying to write simulation data to: ', UC.SimPath '/' UC.SimCSX '\n']);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end;
  if UC.run_simulation;
    npc = 4;
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