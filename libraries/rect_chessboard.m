function rect_chessboard(UCDim, fr4_thickness, L1, L2, eps_subs, tand, mesh_refinement);
  physical_constants;
  UC.layer_td = 1;
  UC.layer_fd = 1;
  UC.td_dumps = 1;
  UC.fd_dumps = 1;
  UC.s_dumps = 1;
  UC.nf2ff = 0;
  UC.s_dumps_folder = "~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters";
  UC.s11_filename_prefix = ["UCDim_" num2str(UCDim) "_lz_" num2str(fr4_thickness) "_L1_" num2str(L1) "_L2_" num2str(L2) "_eps_" num2str(eps_subs) "_tand_" num2str(tand)];

  UC.s11_filename = "Sparameters_";
  UC.s11_subfolder = "rect_chessboard";
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
  UC.dx = UC.dz/3/mesh_refinement;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9, 16.5e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-3;
  UC.SimPath = ["/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/" UC.s11_subfolder "/" UC.s11_filename_prefix];
  UC.SimCSX = "geometry.xml";
  UC.ResultPath = ["~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse"];
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
  substrate.material.type = "const";
  substrate.material.Epsilon = eps_subs;
  substrate.material.tand = tand;
  substrate.material.f0 = 10e9;

  # circle
  rect_chessboard.name = "Chessboard Copper";
  rect_chessboard.lz = 0.05;
  rect_chessboard.rotate = 0;
  rect_chessboard.material.name = "copperRects";
  rect_chessboard.material.Kappa = 56e6;
  rect_chessboard.material.type = "const";
  rect_chessboard.bmaterial.name = "air";
  rect_chessboard.bmaterial.type = "const";
  rect_chessboard.bmaterial.Epsilon = 1;
  rect_chessboard.lx1 = L1;
  rect_chessboard.ly1 = L1;
  rect_chessboard.lx2 = L2;
  rect_chessboard.ly2 = L2;
  rect_chessboard.UClx = UCDim;
  rect_chessboard.UCly = UCDim;
  rect_chessboard.prio = 2;
  rect_chessboard.xycenter = [0, 0];


  layer_list = {{@CreateUC, UC}; {@CreateRect, rectangle};
                                 {@CreateRect, substrate};
                                 {@CreateRectChessboard, rect_chessboard}
                                 };
  material_list = {substrate.material, rectangle.material, rect_chessboard.material, rect_chessboard.bmaterial};
  [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
  if UC.nf2ff == 0;
    [CSX, port] = definePorts(CSX, mesh, UC.f_start);
  elseif UC.nf2ff == 1;
    [CSX, port, nf2ff] = definePortsNF2FF(CSX, mesh, UC);
    phase_center_z = 0
    for i = 2:(size(layer_list)(1));
      for j = 1:(size(layer_list{i}(1)));
        object = layer_list{i}{j, 2};
        phase_center_z -= object.lz;
      endfor;
    endfor;
  endif;
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry;
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  endif;
  if UC.run_simulation;
    openEMS_opts = '';#'-vvv';
    #Settings = ["--debug-PEC", "--debug-material"];
    Settings = ["--numThreads=3"];
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  endif;
  doPortDump(port, UC);
  if UC.nf2ff == 1;
    freq = [2.4e9, 5.2e9, 12e9, 15e9];
    phi = linspace(0, 2*pi, 100);
    theta = linspace(0, pi, 100);
    for f0 = freq;
      printf(['calculating 3D far field for f=' num2str(f0) "\n"]);
      printf(["Using phase center x=0, y=0, z=" num2str(phase_center_z) "\n"]);
      nf2ff = CalcNF2FF(nf2ff, UC.SimPath, f0, theta, phi, 'Mode', UC.run_simulation, 'Center', [0, 0, phase_center_z*2]);
      printf(["WARNING: Shifted the phase-center by a factor of two for optical reasons \n"]);
      E_far_normalized = nf2ff.E_norm{1}/max(nf2ff.E_norm{1}(:));
      DumpFF2VTK([UC.SimPath '/NF2FF_f_' num2str(f0/1e9) '_GHz.vtk'],E_far_normalized,theta*180/pi, phi*180/pi,'scale',1e-2);
      printf(['Far-field pattern for f = ' num2str(f0) ' written to *.vtk\n']);
    endfor;
  endif;
endfunction;