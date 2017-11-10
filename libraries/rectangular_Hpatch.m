function rectangular_Hpatch(UCDim, rect_gap, fr4_thickness);
physical_constants;
UC.layer_td = 1;
UC.layer_fd = 0;
UC.td_dumps = 1;
UC.fd_dumps = 0;
UC.s_dumps = 1;
UC.s_dumps_folder = "/home/stefan/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/SParameters";
UC.s11_filename_prefix = ["UCDim_" num2str(UCDim) "_gap_" num2str(rect_gap) "_lz_" num2str(fr4_thickness)];
UC.s11_filename = "Sparameters_";
UC.s11_subfolder = "rect_Hpatches";
UC.run_simulation = 1;
UC.show_geometry = 0;
UC.grounded = 1;
UC.unit = 1e-3;
UC.f_start = 1e9;
UC.f_stop = 10e9;
UC.lx = UCDim;
UC.ly = UCDim;
UC.lz = c0/ UC.f_start / UC.unit;
UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
UC.dx = UC.dz/2;
UC.dy = UC.dz/2;
UC.dump_frequencies = [2.4e9];
UC.s11_delta_f = 10e6;
UC.EndCriteria = 1e-3;
UC.SimPath = ["/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/rect_Hpatches/" UC.s11_filename_prefix];
confirm_recursive_rmdir(0);
UC.SimCSX = "geometry.xml";
[status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
[status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
BC = {'PMC', 'PMC', 'PEC', 'PEC', 'PML_8', 'PML_8'}; % boundary conditions
FDTD = SetBoundaryCond(FDTD, BC);

rectangle.lx = UCDim;
rectangle.ly = UCDim;
rectangle.lz = 0.5;
rectangle.translate = [0, 0, 0];
rectangle.rotate = 0;
rectangle.prio = 2;
rectangle.xycenter = [0, 0];
rectangle.material.name = "copper";
rectangle.material.Kappa = 56e6;
# Substrate
substrate.lx = UC.lx;
substrate.ly = UC.ly;
substrate.lz = fr4_thickness;
substrate.rotate = 0;
substrate.prio = 2;
substrate.xycenter = [0, 0];
substrate.material.name = "FR4";
substrate.material.Epsilon = 4.4;
substrate.material.tand = 0.02;
substrate.material.f0 = 5e9;
# circle
hollowrect.lx = UC.lx - rect_gap;
hollowrect.ly = UC.ly - rect_gap;
hollowrect.lz = 0.05;

hollowrect.translate = [0, 0, 0];
hollowrect.rotate = 0;
hollowrect.material.name = "copperRect";
hollowrect.material.Kappa = 56e6;
hollowrect.prio = 2;
hollowrect.xycenter = [0, 0];


layer_list = {{@CreateUC, UC}; {@CreateRect, rectangle}; 
                               {@CreateRect, substrate};
                               {@CreateRect, hollowrect}};
material_list = {rectangle.material, substrate.material, hollowrect.material};
[CSX, mesh, param_str] = stack_layers(layer_list, material_list);
[CSX, port] = definePorts(CSX, mesh, UC.f_start);
UC.param_str = param_str;
[CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
if UC.show_geometry;
  CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
endif;
if UC.run_simulation;
  openEMS_opts = '';
  #Settings = ["--debug-PEC", "--debug-material"];
  Settings = [];
  RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
endif;
doPortDump(port, UC);
endfunction;