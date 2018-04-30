function smd_rect(UCDim, fr4_thickness, L1, w1, Res, Cap, eps_FR4, complemential);
  physical_constants;
  UC.layer_td = 0;
  UC.layer_fd = 0;
  UC.td_dumps = 0;
  UC.fd_dumps = 0;
  UC.s_dumps = 1;
  UC.s_dumps_folder = "~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters";
  UC.s11_filename_prefix = ["slab_L_" num2str(L1) "_w_" num2str(w1) "_Ohm_" num2str(Res) "_Cap_" num2str(Cap)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, "_comp");
  endif;
  UC.s11_filename = "Sparameters_";
  UC.s11_subfolder = "smd_rect";
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1e9;
  UC.f_stop = 20e9;
  UC.lx = UCDim;
  UC.ly = UCDim;
  UC.lz = c0/ UC.f_start / 3 / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
  UC.dx = UC.dz/5;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9, 16.5e9];
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
    confirm_recursive_rmdir(0);
    [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
    [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  endif;
  FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
  FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
  BC = {'PMC', 'PMC', 'PEC', 'PEC', 'PML_8', 'PML_8'}; % boundary conditions
  FDTD = SetBoundaryCond(FDTD, BC);
  rectangle.name = "backplate";
  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 0.5;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = "copper";
  #rectangle.material.Kappa = 56e6;
  rectangle.material.type = "const";

  rectangle.material.Kappa = 56e6;

  # Substrate
  substrate.name = "FR4 substrate";
  substrate.lx = UC.lx;
  substrate.ly = UC.ly;
  substrate.lz = fr4_thickness;
  substrate.rotate = 0;
  substrate.prio = 2;
  substrate.xycenter = [0, 0];
  substrate.material.name = "FR4";
  substrate.material.Epsilon = eps_FR4;
  substrate.material.Kappa = 2*pi*10e9*EPS0*eps_FR4*0.02;
  substrate.material.type = "const";
  substrate.zrefinement = 11;
  

  # circular slotted squares
  
  rectring.name = "SquareCirc";
  rectring.Lr = L1; 
  rectring.wr = w1;
  rectring.lr = 0.6;
  rectring.lx = UC.lx;
  rectring.ly = UC.ly;
  rectring.lz = 0.05;
  rectring.rotate = 0;
  rectring.prio = 2;
  rectring.xycenter = [0, 0];
  rectring.material.name = "copperSquares";
  rectring.material.type = "const";
  rectring.material.Kappa = 56e6;
  rectring.resmaterial.name = "SMDResistor";
  rectring.resmaterial.type = "const";
  rectring.resmaterial.Kappa = rectring.lr/(Res*w1*rectring.lz*UC.unit);
  rectring.resmaterial.Epsilon = Cap*rectring.lr/(w1*rectring.lz*UC.unit*EPS0);
  rectring.bmaterial.name = "air";
  rectring.bmaterial.type = "const";
  rectring.bmaterial.Epsilon = 1;
  rectring.refinement = 15;


  layer_list = {@CreateUC, UC; @CreateRect, rectangle;
                               @CreateRect, substrate;
                               @CreateRectRing, rectring;
                                 };
  material_list = {rectangle.material, substrate.material,rectring.material, rectring.bmaterial, rectring.resmaterial};
  [CSX, mesh, param_str, UC] = stack_layers(layer_list, material_list);
  [CSX, port] = definePorts(CSX, mesh, UC.f_start);
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

    #Settings = ["--debug-PEC", "--debug-material"];
    Settings = [''];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end;
  doPortDump(port, UC);
endfunction;