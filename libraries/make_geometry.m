function vary_rect_L_kappa(L, kappa);
unit = 1e-3;
physical_constants;


# decite what to do
calculate = 1;
td_results = 1;
mode_detection = 0;
show_geometry = 1;
s11_filename_prefix = ["3-10_GHz_L_" num2str(L) "_kappa_" num2str(kappa) ];
folder_postfix = "/rect_patches";
project = "rect_patches";
comment = "# no large H-es \n";
confirm_recursive_rmdir(1);
maxNrTS = 120000;
# end of decision section
# define simulation parameters
tanD_FR4 = kappa;
eps_FR4 = 4.4;
f_start = 3e9;
lambda_max = c0/f_start/unit;
f_stop = 10e9;
f0 = (f_start + f_stop)/2;
end_criterion = 1e-6;
max_res = c0 / (f_stop) / unit / 20;
mesh_res = [1, 1, 1]*max_res;
Cx = 44; # size of the unit-cell
Cy = 44;
Lx = Cx;
Ly = Cy;
Lz = lambda_max/2;
Sim_Path = ['/mnt/hgfs/E/openEMS/layerbased_metamaterials/' project '/' s11_filename_prefix '/'];
Sim_CSX = 'Wifi_Metaabsorber.xml';
openEMS_opts = '';
Settings = ["--debug-PEC", "--debug-material"];
[status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
[status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder
# end of simulation parameters

# initialize FDTD operator and set up geometry
FDTD = InitFDTD('EndCriteria', end_criterion, 'NrTS', maxNrTS);
FDTD = SetGaussExcite(FDTD,0.5*(f_start+f_stop),0.5*(f_stop-f_start));
BC = {'PMC', 'PMC', 'PEC', 'PEC', 'PML_8', 'PML_8'}; % boundary conditions
FDTD = SetBoundaryCond(FDTD, BC);
CSX = InitCSX();
SimBox = [Lx, Ly, Lz];
mesh.x = SmoothMeshLines([-Lx/2, Lx/2], mesh_res(1));
mesh.y = SmoothMeshLines([-Ly/2, Ly/2], mesh_res(2));
mesh.z = SmoothMeshLines([-8*Lz/9, Lz/9], mesh_res(3));
# end of FDTD/geometry initialization

# define used materials
sigmaCu = 56e6;
CSX = AddMaterial(CSX, 'copperBP');
CSX = AddMaterial(CSX, 'Air');
CSX = SetMaterialProperty( CSX, 'copperBP', 'Kappa', sigmaCu); # conductivity
CSX = AddMaterial(CSX, 'copperH1');
CSX = SetMaterialProperty( CSX, 'copperH1', 'Kappa', sigmaCu); # conductivity
CSX = AddMaterial(CSX, 'copperH2');
CSX = SetMaterialProperty( CSX, 'copperH2', 'Kappa', sigmaCu); # conductivity
CSX = AddMaterial(CSX, 'Substrate');
CSX = SetMaterialProperty(CSX, 'Substrate', 'Epsilon', eps_FR4, 'Kappa', tanD_FR4*f0*2*pi*EPS0*4.4);
# create metallic backplane
# collecting simulation parameters
paralist = ["# dimensions in " num2str(unit) " meters \n" \
            "# sigmaCU = " num2str(sigmaCu) " S/m, epsFR4 = " \
            num2str(eps_FR4) "+i* " num2str(tanD_FR4*eps_FR4) "\n" \
            comment];
# end of parameter collection
BP.lx = Cx;
BP.ly = Cy;
BP.lz = 0.1;
BP.prio = 10;
BP.material = 'copperBP';
BP.center = [0, 0, -BP.lz/2];
[CSX, params, lastz] = CreateRect(CSX, BP, BP.center, 0); 
zvals = [lastz.c-lastz.lz/2, lastz.c+lastz.lz/2];
paralist = horzcat(paralist, params);
# end metallic backplane
# subsrtate layer between backplane and H-layer
S1.lx = Cx;
S1.ly = Cy;
S1.lz = 1;
S1.prio = 2;
S1.material = "Substrate";
S1.center = [0, 0, lastz.c-lastz.lz/2-S1.lz/2];
[CSX, params, lastz] = CreateRect(CSX, S1, S1.center, 0);
paralist = horzcat(paralist, params);

zvals = horzcat(zvals, [lastz.c-lastz.lz/2]);
# end larger H-grid


mesh.x = SmoothMeshLines(mesh.x, mesh_res(1), 1.3, 2);
mesh.y = SmoothMeshLines(mesh.y, mesh_res(2), 1.3, 2);
mesh.z = SmoothMeshLines([mesh.z, zvals], mesh_res(3), 1.3, 2);
CSX = DefineRectGrid( CSX, unit, mesh );
mesh = AddPML(mesh, [0 0 0 0 8 8]);
p1 = [mesh.x(1), mesh.y(1), mesh.z(16)];
[zmax, idx] = min(abs(mesh.z+lambda_max/3))
p2 = [mesh.x(end), mesh.y(end), mesh.z(idx)];
p3 = p1;
p4 = [mesh.x(end), mesh.y(end), mesh.z(end-10)];
func_E{1} = 0;
func_E{2} = -1;
func_E{3} = 0;
func_H{1} = 1;
func_H{2} = 0;
func_H{3} = 0;
[CSX, port{1}] = AddWaveGuidePort(CSX, 10, 1, p1, p2, 2, func_E, func_H, 1, 1);
[CSX, port{2}] = AddWaveGuidePort(CSX, 10, 2, p3, p4, 2, func_E, func_H, 1, 0);
if td_results;
  CSX = AddDump(CSX, "E_meta_t_xz");
  startMETA = [mesh.x(1), 0, mesh.z(end)];
  stopMETA  = [mesh.x(end), 0, mesh.z(1)];
  CSX = AddBox(CSX, "E_meta_t_xz", 10, startMETA, stopMETA);
  
  CSX = AddDump(CSX, "E_meta_t_yz");
  startMETA = [0, mesh.y(1), mesh.z(end)];
  stopMETA  = [0, mesh.y(end), mesh.z(1)];
  CSX = AddBox(CSX, "E_meta_t_yz", 10, startMETA, stopMETA);
  
  CSX = AddDump(CSX, "E_meta_t_xy");
  startMETA = [mesh.x(1), mesh.y(1), S1.center(3)];
  stopMETA  = [mesh.x(end), mesh.y(end), S1.center(3)];
  CSX = AddBox(CSX, "E_meta_t_xy", 10, startMETA, stopMETA);
  
  CSX = AddDump(CSX, "E_meta_t_xy2");
  startMETA2 = [mesh.x(1), mesh.y(1), S2.center(3)];
  stopMETA2  = [mesh.x(end), mesh.y(end), S2.center(3)];
  CSX = AddBox(CSX, "E_meta_t_xy2", 10, startMETA2, stopMETA2);
  
  CSX = AddDump(CSX, "E_meta_t_xy3");
  startMETA3 = [mesh.x(1), mesh.y(1), S3.center(3)-S3.lz/4];
  stopMETA3  = [mesh.x(end), mesh.y(end), S3.center(3)-S3.lz/4];
  CSX = AddBox(CSX, "E_meta_t_xy3", 10, startMETA3, stopMETA3);
end;

if mode_detection;
  probe_pos_off1 = S1.center;
  probe_pos_off2 = S3.center;
  probe_positions = [[0,0,0]+probe_pos_off1; 
                     [-BP2.lx/2, -BP2.ly/2,0]+probe_pos_off1; 
                     [BP2.lx/2,0,0]+probe_pos_off1;
                     [BP2.lx/2, BP2.ly/2,0]+probe_pos_off1;
                     [0,0,0]+probe_pos_off2; 
                     [-BP2.lx/2, -BP2.ly/2,0]+probe_pos_off2; 
                     [BP2.lx/2,0,0]+probe_pos_off2;
                     [BP2.lx/2, BP2.ly/2,0]+probe_pos_off2];
  for idx = 1:size(probe_positions)(1)
    dumpname = ["E" num2str(idx)];
    CSX = AddDump(CSX, dumpname, 'FileType', 1);
    CSX = AddPoint(CSX, dumpname, 1, probe_positions(idx, :));
  end;
end;

WriteOpenEMS([Sim_Path '/' Sim_CSX], FDTD, CSX);
if show_geometry;
  CSXGeomPlot([Sim_Path '/' Sim_CSX]);
end;
if calculate;
  openEMS_opts = '';
  Settings = ["--debug-PEC", "--debug-material"];
  RunOpenEMS(Sim_Path, Sim_CSX, openEMS_opts, Settings);  
  freq = linspace(f_start, f_stop, 2001);
  [portf] = write_s11_f(port, Sim_Path, freq, paralist, f_start, f_stop, [project "/" s11_filename_prefix]);
  %[portt] = write_s11_t(port, Sim_Path, freq, params, f_start, f_stop, s11_filename_prefix)
end;
endfunction;