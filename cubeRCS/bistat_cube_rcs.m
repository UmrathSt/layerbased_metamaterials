function retval = bistat_cube_rcs(alpha_y, freq, L, epsRe, epsIm, dump_TD_slices, show_geometry, Path);
% Do a monostatic RCS calculation at the frequency "freq" for a dielectric cube with
% permittivity eps = epsRe +  i*epsIm
% which is rotated around the y-axis by alpha_y
% A plane wave is propagating along the z-direction and polarized in x-direction
% 

%% setup the simulation
physical_constants;
unit = 1e-3; % all length in cm
rot_angle = alpha_y; %incident angle (to x-axis) in rad
post_processing_only = 0;

% size of the simulation box

PW_Box = L*1.05; %1.05

%% setup FDTD parameter & excitation function
 % start frequency
% stop  frequency
f0 = freq;
%% Scatterer to be studied will be a box of siz
%% Lx, Ly, Lz
Box.Lx = L;
Box.Ly = L;
Box.Lz = L;
Box.epsRe = epsRe;
Box.epsIm = epsIm;
%% FDTD only knows about conductivity, not the imaginary parts of epsilon/mu
Box.kappa = EPS0 * 2 * pi * f0 * Box.epsIm; 

FDTD = InitFDTD('EndCriteria', 5e-4);
FDTD = SetGaussExcite( FDTD, 0.75*freq, 0.3*freq );
BC = [3 3 1 3 3 3];  % set boundary conditions to PML
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh
max_res = c0 / freq / unit / 20; % cell size: lambda/20
CSX = InitCSX();
SimBox = PW_Box + 2*8*max_res;

%create mesh
smooth_mesh = SmoothMeshLines([0 Box.Lx/2], max_res/sqrt(epsRe));
smooth_mesh = SmoothMeshLines([smooth_mesh SimBox/2], max_res);
mesh.x = unique([-smooth_mesh smooth_mesh]);
mesh.y = smooth_mesh;
mesh.z = mesh.x;

%% create metal sphere
CSX = AddMaterial(CSX, 'Cube' ); % create a perfect electric conductor (PEC)
CSX = SetMaterialProperty(CSX, 'Cube', 'Epsilon', Box.epsRe, 'Kappa', Box.kappa);
start_coords = [Box.Lx/2, Box.Ly/2, Box.Lz/2];
CSX = AddBox(CSX,'Cube', 1, start_coords, -start_coords);

%% plane wave excitation
k_dir = [sin(alpha_y), 0, cos(alpha_y)]; % plane wave direction
E_dir = [cos(alpha_y), 0, -sin(alpha_y)]; % plane wave polarization --> E_z

CSX = AddPlaneWaveExcite(CSX, 'plane_wave', k_dir, E_dir, f0);
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
start = [mesh.x(1)     mesh.y(1)     mesh.z(1)];
stop  = [mesh.x(end) mesh.y(end) mesh.z(end)];
[CSX nf2ff] = CreateNF2FFBox(CSX, 'nf2ff', start, stop, 'Directions', [1, 1, 0, 1, 1, 1]);
save nf2ff_struct.dat nf2ff;
% add 8 lines in all direction as pml spacing
mesh = AddPML(mesh,8);

CSX = DefineRectGrid( CSX, unit, mesh );

%% prepare simulation folder
Sim_Path = [Path 'Cube_RCS_alpha_y_' num2str(alpha_y*180/pi, "%.1f")];
Sim_CSX = 'Cube_RCS.xml';
confirm_recursive_rmdir(0); % overwrite path if it exists
if !(post_processing_only);
    [status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
    [status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder
end;

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
nf2ff = CalcNF2FF(nf2ff, Sim_Path, f, theta+alpha_y, 0, 'Mode',0, 'Mirror', {1, 'PMC', 0});
rcs = 4*pi*nf2ff.P_rad{1}(:)./Pin(1);

retval = rcs;
% cleanup
%nf2ff_cleanup([Sim_Path, "/nf2ff_"]);

return 
endfunction;