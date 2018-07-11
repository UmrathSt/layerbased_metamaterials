function retval = bistat_PECcube_rcs(alpha_y, freq, L, dump_TD_slices, show_geometry, Path);
% Do a monostatic RCS calculation at the frequency "freq" for a dielectric cube with
% which is rotated around the y-axis by alpha_y
% A plane wave is propagating along the z-direction and polarized in x-direction
% 

%% setup the simulation
physical_constants;
unit = 1e-3; % all length in cm
rot_angle = alpha_y; %incident angle (to x-axis) in rad
post_processing_only = 0;

% size of the simulation box



%% setup FDTD parameter & excitation function
 % start frequency
% stop  frequency
f_stop = freq;
f_start = 1e9;
fc = (f_start+f_stop)/2;
f0 = fc;
fw = (f_stop-f_start)
%% Scatterer to be studied will be a box of siz
%% Lx, Ly, Lz
Box.Lx = L;
Box.Ly = L;
Box.Lz = L;

FDTD = InitFDTD('EndCriteria', 1e-4);
FDTD = SetGaussExcite( FDTD, fc, fw);
BC = [0 3 1 3 3 3];  % set boundary conditions to PML
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh
max_res = c0 / freq / unit / 20; % cell size: lambda/20
CSX = InitCSX();
PW_Box = L+20*max_res; %1.05
SimBox = PW_Box + 2*8*max_res;

%create mesh
smoothx = SmoothMeshLines([0 Box.Lx/2, SimBox/2], max_res);
smoothy = SmoothMeshLines([0 Box.Ly/2, SimBox/2], max_res);
mesh.x = smoothx;
mesh.y = unique([-smoothy, smoothy]);
mesh.z = unique([-mesh.x,mesh.x]);

%% create metal cube
CSX = AddMetal(CSX, 'Cube' ); % create a perfect electric conductor (PEC)

start_coords = [Box.Lx/2, Box.Ly/2, Box.Lz/2];
CSX = AddBox(CSX,'Cube', 1, start_coords, -start_coords);

%% plane wave excitation
k_dir = [0, cos(alpha_y), sin(alpha_y)]; % plane wave direction
E_dir = [1, 0, 0]; % plane wave polarization --> E_z

CSX = AddPlaneWaveExcite(CSX, 'plane_wave', k_dir, E_dir, f0);
start = [mesh.x(1) -PW_Box/2 -PW_Box/2];
stop  = [PW_Box/2, PW_Box/2, PW_Box/2];
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
start = [mesh.x(1)     mesh.y(1)     mesh.z(1)];
stop  = [mesh.x(end) mesh.y(end) mesh.z(end)];
[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', start, stop, 'Directions', [0, 1, 1, 1, 1, 1]);

% add 8 lines in all direction as pml spacing
mesh = AddPML(mesh,[0, 8, 8, 8, 8, 8]);

CSX = DefineRectGrid( CSX, unit, mesh );

%% prepare simulation folder

Sim_Path = [Path 'Cube_RCS_alpha_y_' num2str(alpha_y*180/pi, "%.1f")];
confirm_recursive_rmdir(0); % overwrite path if it exists
if !(post_processing_only);
    [status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
    [status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder
end;
save("-text", strcat(Sim_Path, "/", "nf2ff_struct.dat"), "nf2ff")
Sim_CSX = 'Cube_RCS.xml';



%% write openEMS compatible xml-file
WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );

%% show the structure
%CSXGeomPlot( [Sim_Path '/' Sim_CSX] );

%% run openEMS
if show_geometry;
  CSXGeomPlot([Sim_Path '/' Sim_CSX]);
endif;
settings = [''];
openEMS_opts = ['--engine=multithreaded --numThreads=6'];
if !(post_processing_only);
    RunOpenEMS( Sim_Path, Sim_CSX, openEMS_opts, settings);
endif;

%%

%%
f = freq;
EF = ReadUI( 'et', Sim_Path, f ); % time domain/freq domain voltage
Pin = 0.5*norm(E_dir)^2/Z0 .* abs(EF.FD{1}.val).^2;
theta = (0:1440)*pi/720;
nf2ff = CalcNF2FF(nf2ff, Sim_Path, f, theta+alpha_y, 0, 'Mode',0, 'Mirror', {0, 'PEC', 0});
rcs = 4*pi*nf2ff.P_rad{1}(:)./Pin(1);

retval = rcs;
% cleanup
%nf2ff_cleanup([Sim_Path, "/nf2ff_"]);

return 
endfunction;