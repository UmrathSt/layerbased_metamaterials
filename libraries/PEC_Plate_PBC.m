function PEC_Plate_PBC(UCDim, fr4_thickness, R1, w1, R2, w2, eps_subs, tand, polarization, phi_xy, theta_z, mesh_refinement, complemential)
  physical_constants;
  UC.layer_td = 1;
  UC.layer_fd = 0;
  UC.td_dumps = 1;
  UC.fd_dumps = 0;
  UC.s_dumps = 0;
  UC.nf2ff = 0;
  %if strcmp(uname().nodename, 'Xeon');
  %  UC.s_dumps_folder = '~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse/SParameters';
  %else;
    UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  %end;
  UC.s_dumps_folder = '~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse/SParameters';
  UC.s11_filename_prefix = ['UCDim_' num2str(UCDim) '_lz_' num2str(fr4_thickness) '_R1_' num2str(R1) '_w1_' num2str(w1) '_R2_' num2str(R2) '_w2_' num2str(w2) '_eps_' num2str(eps_subs) '_tand_' num2str(tand)];
  if complemential
    UC.s11_filename_prefix = horzcat(UC.s11_filename_prefix, '_comp');
  end
  UC.s11_filename = 'Sparameters_';
  UC.s11_subfolder = 'PEC_Plate_PBC';
  UC.run_simulation = 1;
  UC.show_geometry = 0;
  UC.grounded = 1;
  UC.unit = 1e-3;
  UC.f_start = 1e9;
  UC.f_stop = 20e9;
  UC.k0 = (UC.f_start+UC.f_stop)*pi/c0*UC.unit;
  UC.lx = UCDim;
  UC.ly = UCDim/10;
  UC.lz = c0/ UC.f_start*2  / UC.unit;
  UC.dz = c0 / (UC.f_stop) / UC.unit / 10;
  UC.dx = UC.dz;
  UC.dy = UC.dx;
  UC.dump_frequencies = [2.4e9, 5.2e9, 16.5e9];
  UC.s11_delta_f = 10e6;
  UC.EndCriteria = 1e-3;
  UC.SimCSX = 'geometry.xml';
  %if strcmp(uname().nodename, 'Xeon');
  %  display('Working on Xeon machine \n');
  %  UC.SimPath = ['/media/stefan/Daten/openEMS/' UC.s11_subfolder '/' UC.s11_filename_prefix];
  %  UC.ResultPath = ['~/Arbeit/openEMS/layerbased_metamaterials/Ergebnisse'];
  %else;
    UC.SimPath = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/' UC.s11_subfolder '/' UC.s11_filename_prefix];
    UC.ResultPath = ['~/Arbeit/openEMS/git_layerbased/layerbased_metamaterials/Ergebnisse'];
  %end;
  if UC.run_simulation
    %confirm_recursive_rmdir(0);
    [status, message, messageid] = rmdir(UC.SimPath, 's' ); % clear previous directory
    [status, message, messageid] = mkdir(UC.SimPath ); % create empty simulation folder
  end
  FDTD = InitFDTD('EndCriteria', UC.EndCriteria);
  %FDTD = SetGaussExcite(FDTD, 0.5*(UC.f_start+UC.f_stop),0.5*(UC.f_stop-UC.f_start));
  FDTD = SetPBCGaussExcite(FDTD,(UC.f_start+UC.f_stop)/2, UC.f_stop-UC.f_start);
  BC = {'PBC', 'PBC', 'PBC', 'PBC', 'PML_8', 'PML_8'}; % boundary conditions
  FDTD = SetBoundaryCond(FDTD, BC);
  % define the pbc properties which shall be read by openEMS from the
  % xml-file;
  FDTD.PeriodicBoundary.ATTRIBUTE.k_pbc_x = sin(theta_z)*cos(phi_xy)*UC.k0*UC.lx;
  FDTD.PeriodicBoundary.ATTRIBUTE.k_pbc_y = sin(theta_z)*sin(phi_xy)*UC.k0*UC.ly;

 % FDTD.PeriodicBoundary
  rectangle.name = 'backplate';
  rectangle.lx = UCDim;
  rectangle.ly = UCDim;
  rectangle.lz = 2;
  rectangle.rotate = 0;
  rectangle.prio = 2;
  rectangle.xycenter = [0, 0];
  rectangle.material.name = 'copper';
  rectangle.material.Kappa = 0;
  rectangle.material.type = 'const';
  %rectangle.material.Epsilon = 1;



  layer_list = {@CreateUC, UC; @CreateRect, rectangle};
  material_list = {rectangle.material};

  [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
  if UC.nf2ff == 0
    [CSX, port] = definePBCPorts(CSX, mesh, UC.f_start, (UC.f_start+UC.f_stop)/2, UC.unit, polarization, phi_xy, theta_z);
  elseif UC.nf2ff == 1
    [CSX, port, nf2ff] = definePortsNF2FF(CSX, mesh, UC);
    phase_center_z = 0;
    for i = 2:(size(layer_list,1))
      for j = 1:(size(layer_list{i},1))
        object = layer_list{i}{j, 2};
        phase_center_z = phase_center_z-object.lz;
      end
    end
  end
  UC.param_str = param_str;
  [CSX] = defineFieldDumps(CSX, mesh, layer_list, UC);
  WriteOpenEMS([UC.SimPath '/' UC.SimCSX], FDTD, CSX);
  if UC.show_geometry
    CSXGeomPlot([UC.SimPath '/' UC.SimCSX]);
  end
  if UC.run_simulation
    openEMS_opts = '--engine=multithreaded --numThreads=4 --debug-operator';%'-vvv';
    %Settings = ['--debug-PEC', '--debug-material'];
    Settings = 'verbose=3';
    RunOpenEMS(UC.SimPath, UC.SimCSX, openEMS_opts, Settings);
  end
  doPortDump(port, UC);
  if UC.nf2ff == 1
    freq = [2.4e9, 5.2e9, 12e9, 15e9];
    phi = linspace(0, 2*pi, 100);
    theta = linspace(0, pi, 100);
    for f0 = freq
      printf(['calculating 3D far field for f=' num2str(f0) '\n']);
      printf(['Using phase center x=0, y=0, z=' num2str(phase_center_z) '\n']);
      nf2ff = CalcNF2FF(nf2ff, UC.SimPath, f0, theta, phi, 'Mode', UC.run_simulation, 'Center', [0, 0, phase_center_z*2]);
      printf('WARNING: Shifted the phase-center by a factor of two for optical reasons \n');
      E_far_normalized = nf2ff.E_norm{1}/max(nf2ff.E_norm{1}(:));
      DumpFF2VTK([UC.SimPath '/NF2FF_f_' num2str(f0/1e9) '_GHz.vtk'],E_far_normalized,theta*180/pi, phi*180/pi,'scale',1e-2);
      printf(['Far-field pattern for f = ' num2str(f0) ' written to *.vtk\n']);
    end
  end
end
