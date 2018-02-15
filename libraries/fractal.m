function fractal(UCDim, L, dL, fr4_thickness, eps_FR4, tand, complemential=0);
physical_constants;
UC.layer_td = 1;
UC.layer_fd = 0;
UC.td_dumps = 1;
UC.fd_dumps = 0;
UC.s_dumps = 1;
  machine = uname().nodename;
  if length(machine) == 4;
    if machine == 'Xeon';
      UC.s_dumps_folder = '~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters';
    endif;
  else;
    UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  endif;
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_L_' num2str(L) '_dL_' num2str(dL) '_epsFR4_' num2str(eps_FR4) '_tand_' num2str(tand)];
  complemential = complemential;
  if complemential;
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  endif;

UC.s_dumps_folder = '/home/stefan/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/SParameters';
UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_L_' num2str(L) '_dL_' num2str(dL) '_lz_' num2str(fr4_thickness) '_epsFR4_' num2str(eps_FR4) '_tand_' num2str(tand)];
UC.s11_filename = 'Sparameters_';
UC.s11_subfolder = 'fractal';
UC.run_simulation = 1;
UC.show_geometry = 1;
UC.grounded = 1;
UC.unit = 1e-3;
UC.f_start = 2.5e9;
UC.f_stop = 20e9;
UC.lx = UCDim;
UC.ly = UCDim;
UC.lz = c0/ UC.f_start /2/ UC.unit;
UC.dz = c0 / (UC.f_stop) / UC.unit / 20;
UC.dx = UC.dz;
UC.dy = UC.dz;
UC.dump_frequencies = [2.4e9];
UC.s11_delta_f = 10e6;
UC.EndCriteria = 1e-3;
UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/rect_Hpatches/' UC.s11_filename_prefix];
confirm_recursive_rmdir(0);
UC.SimCSX = 'geometry.xml';
  if length(machine) == 4;
    if machine == 'Xeon';
      UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
      UC.ResultPath = ['~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse'];
    endif;
  else;
    UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
    UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  endif;
  if UC.run_simulation;
    confirm_recursive_rmdir(0);
    [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
    [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  endif;
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
rectangle.material.name = 'copper';
rectangle.material.Kappa = 56e6;
rectangle.material.type = 'const';
# Substrate
substrate.lx = UC.lx;
substrate.ly = UC.ly;
substrate.lz = fr4_thickness;
substrate.rotate = 0;
substrate.prio = 2;
substrate.xycenter = [0, 0];
substrate.material.name = 'FR4';
substrate.material.Epsilon = eps_FR4;
substrate.material.tand = tand;
substrate.material.f0 = 5e9;
substrate.material.type = 'const';
substrate.zrefinement = 6;
# rubber
rubber.lx = UC.lx;
rubber.ly = UC.ly;
rubber.lz = 0.6;
rubber.rotate = 0;
rubber.prio = 2;
rubber.xycenter = [0, 0];
rubber.material.name = 'rubber';
rubber.material.Epsilon = 2.5;
rubber.material.Kappa = 40;
rubber.material.type = 'const';
rubber.zrefinement = 3;
# circle
fractal.UClx = UCDim;
fractal.UCly = UCDim;
fractal.L = L;
fractal.dL = dL;
fractal.dLshift = L/4.4;
fractal.lz = 0.05;
fractal.translate = [0, 0, 0];
fractal.rotate = 0;
fractal.material.name = 'copperRect';
fractal.material.Kappa = 56e6;
fractal.material.type = 'const';
fractal.prio = 2;
fractal.xycenter = [0, 0];
#
hrectangle.UClx = UCDim;
hrectangle.UCly = UCDim;
hrectangle.lx = UCDim-4*dL;
hrectangle.ly = UCDim-4*dL;
hrectangle.dx = dL;
hrectangle.dy = dL;
hrectangle.lz = 0.05;
hrectangle.translate = [0, 0, 0];
hrectangle.rotate = 0;
hrectangle.material.name = 'copper';
hrectangle.material.Kappa = 56e6;
hrectangle.material.type = 'const';
hrectangle.bmaterial.name = 'FR4';
hrectangle.prio = 2;
hrectangle.xycenter = [0, 0];




layer_list = {@CreateUC, UC; @CreateRect, rectangle; 
                             @CreateRect, rubber;
                            % @CreateHRectangle, hrectangle;
                             @CreateRect, substrate;
                             @CreateFractal, fractal};
material_list = {rectangle.material, substrate.material, fractal.material, rubber.material};
[CSX, mesh, param_str] = stack_layers(layer_list, material_list);
[CSX, port] = definePorts(CSX, mesh, UC.f_start);
UC.param_str = param_str;
[CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
if UC.show_geometry;
  CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
endif;
if UC.run_simulation;
  openEMS_opts = '--engine=multithreaded --numThreads=2';#'-vvv';
  #Settings = ['--debug-PEC', '--debug-material'];
  Settings = [];
  RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
endif;
doPortDump(port, UC);
endfunction;