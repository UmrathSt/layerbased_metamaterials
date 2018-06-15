function retval = bistat_PECsphere_rcs(alpha_y, freq, R, dump_TD_slices, show_geometry, Path);
% Do a monostatic RCS calculation at the frequency "freq" for a dielectric sphere with
% which is rotated around the y-axis by alpha_y
% A plane wave is propagating along the z-direction and polarized in x-direction
% 
retval = 0;
%% setup the simulation
physical_constants;
unit = 1e-3; % all length in cm
rot_angle = alpha_y; %incident angle (to x-axis) in rad
post_processing_only = 0;

% size of the simulation box

PW_Box = 2*R*1.05; %1.05

%% setup FDTD parameter & excitation function
 % start frequency
% stop  frequency
%% Scatterer to be studied will be a box of siz
%% Lx, Ly, Lz
Sphere.R = R;

FDTD = InitFDTD('EndCriteria', 5e-4);
freq_min = 1e9;
freq_max = freq;
freq_center = (freq_min+freq_max)/2;
FDTD = SetGaussExcite( FDTD, freq_center, 0.5*(freq_max-freq_min) );
BC = [3 3 1 3 3 3];  % set boundary conditions to PML
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh
max_res = c0 / freq_max / unit / 20; % cell size: lambda/20
nf2ff_res = c0 / freq_max / unit / 15;
sphere_res = max_res;

CSX = InitCSX();
lambda_max = c0 / freq_min / unit;
SimBox = PW_Box + 2*8*max_res ;%+ lambda_max/2;

%create mesh
smooth_mesh = AutoSmoothMeshLines([0 Sphere.R], sphere_res);
smooth_mesh = AutoSmoothMeshLines([smooth_mesh SimBox/2], max_res);
mesh.x = unique([-smooth_mesh smooth_mesh]);
mesh.y = smooth_mesh;
mesh.z = mesh.x;

%% create metal sphere
CSX = AddMetal(CSX, 'PECsphere' ); % create a perfect electric conductor (PEC)


CSX = AddSphere(CSX,'PECsphere', 1, [0,0,0], R);

%% plane wave excitation
k_dir = [sin(alpha_y), 0, cos(alpha_y)]; % plane wave direction
E_dir = [cos(alpha_y), 0, -sin(alpha_y)]; % plane wave polarization --> E_z

CSX = AddPlaneWaveExcite(CSX, 'plane_wave', k_dir, E_dir, freq_min);
start = [-PW_Box/2 -PW_Box/2 -PW_Box/2];
stop  = -start;
CSX = AddBox(CSX, 'plane_wave', 0, start, stop);
if dump_TD_slices;
  start = [mesh.x(1)   0 mesh.z(1)];
  stop  = [mesh.x(end) 0 mesh.z(end)];
  CSX = AddDump(CSX, "Exz");
  CSX = AddBox(CSX, "Exz", 1, start, stop);
  % dump boxes
  CSX = AddDump(CSX, 'Exy');
  start = [mesh.x(1)   mesh.y(1)   0];
  stop  = [mesh.x(end) mesh.y(end) 0];
  CSX = AddBox(CSX, 'Exy', 0, start, stop);
endif;
%%nf2ff calc
mesh = AddPML(mesh,8);
CSX = DefineRectGrid( CSX, unit, mesh );
start = [mesh.x(8)     mesh.y(8)     mesh.z(8)];
stop  = [mesh.x(end-9) mesh.y(end-9) mesh.z(end-9)];
[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', start, stop, 'Directions', [1, 1, 0, 1, 1, 1]);

%% prepare simulation folder

Sim_Path = [Path 'Sphere_RCS_alpha_y_' num2str(alpha_y*180/pi, "%.1f")];
confirm_recursive_rmdir(0); % overwrite path if it exists
if !(post_processing_only);
    [status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
    [status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder
end;
save("-text", strcat(Sim_Path, "/", "nf2ff_struct.dat"), "nf2ff")
Sim_CSX = 'Sphere_RCS.xml';



%% write openEMS compatible xml-file
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

%% show the structure
%CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

%% run openEMS
if show_geometry;
  CSXGeomPlot([Sim_Path '/' Sim_CSX]);
endif;
settings = [''];
openEMS_opts = ['--engine=multithreaded --numThreads=4'];
if !(post_processing_only);
    RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts, settings);
endif;


return 
end;