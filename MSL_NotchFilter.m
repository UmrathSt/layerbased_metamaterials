%
% Tutorials / MSL_NotchFilter
%
% Describtion at:
% http://openems.de/index.php/Tutorial:_Microstrip_Notch_Filter
%
% Tested with
%  - Matlab 2011a / Octave 4.0
%  - openEMS v0.0.33
%
% (C) 2011-2015 Thorsten Liebig <thorsten.liebig@gmx.de>

close all
clear
clc

%% setup the simulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
physical_constants;
unit = 1e-3; % specify everything in um
MSL_length = 25.000;
MSL_width = 1.5;
substrate_thickness = 3.2;
substrate_epr = 4.6;
stub_length = 1;
f_max = 1e9;
addpath('./libraries');



%% setup FDTD parameters & excitation function %%%%%%%%%%%%%%%%%%%%%%%%%%%%
FDTD = InitFDTD();
FDTD = SetGaussExcite( FDTD, f_max/2, f_max/2 );
BC   = {'PML_8' 'PML_8' 'MUR' 'MUR' 'PEC' 'MUR'};
FDTD = SetBoundaryCond( FDTD, BC );

%% setup CSXCAD geometry & mesh %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSX = InitCSX();
resolution = c0/(f_max*sqrt(substrate_epr))/unit /40; % resolution of lambda/50
mesh.x = SmoothMeshLines( [0 MSL_width/2+[2*resolution/3 -resolution/3]/20], resolution/4, 1.5 ,0 );
mesh.x = SmoothMeshLines( [-MSL_length -mesh.x -0.15, 0.15 mesh.x MSL_length], resolution, 1.5 ,0 );
mesh.y = SmoothMeshLines( [0 MSL_width/2+[-resolution/3 +resolution/3*2]/20], resolution/4 , 1.5 ,0);
mesh.y = SmoothMeshLines( [-15*MSL_width -mesh.y mesh.y stub_length+[-resolution/3 +resolution/3*2]/4 15*MSL_width+stub_length], resolution, 1.3 ,0);
mesh.z = SmoothMeshLines( [linspace(0,substrate_thickness,5), substrate_thickness+linspace(0,0.35,5), 5*substrate_thickness], resolution/10 );
CSX = DefineRectGrid( CSX, unit, mesh );

%% substrate
CSX = AddMaterial( CSX, 'FR4' );
CSX = SetMaterialProperty( CSX, 'FR4', 'Epsilon', substrate_epr );
start = [mesh.x(1),   mesh.y(1),   0];
stop  = [mesh.x(end), mesh.y(end), substrate_thickness];
CSX = AddBox( CSX, 'FR4', 0, start, stop );

%% MSL port
CSX = AddMetal( CSX, 'PEC' );
portstart = [ mesh.x(1), -MSL_width/2, substrate_thickness];
portstop  = [ -0.25,  MSL_width/2, 0];
[CSX,port{1}] = AddMSLPort( CSX, 999, 1, 'PEC', portstart, portstop, 0, [0 0 -1], 'ExcitePort', true, 'FeedShift', 10*resolution, 'MeasPlaneShift',  MSL_length/3);

portstart = [mesh.x(end), -MSL_width/2, substrate_thickness];
portstop  = [0.25          ,  MSL_width/2, 0];
[CSX,port{2}] = AddMSLPort( CSX, 999, 2, 'PEC', portstart, portstop, 0, [0 0 -1], 'MeasPlaneShift',  MSL_length/3 );

%% Filter-stub
%start = [-MSL_width/2,  MSL_width/2, substrate_thickness];
%stop  = [ MSL_width/2,  MSL_width/2+stub_length, substrate_thickness];
%CSX = AddBox( CSX, 'PEC', 999, start, stop );
smdres.unit = 1e-3;
smdres.Resistance = 100;
smdres.prio = 10;
smdres.xycenter = [0,0];
[CSX, params] = CreateSMDResistor(CSX, smdres, [0,0,substrate_thickness+0.35/2], pi/2);
 
%% write/show/run the openEMS compatible xml-file
Sim_Path = '/mnt/hgfs/E/openEMS/layerbased_metamaterials/Simulation/MSL_Notchfilter';
Sim_CSX = 'msl.xml';

[status, message, messageid] = rmdir( Sim_Path, 's' ); % clear previous directory
confirm_recursive_rmdir(1);
[status, message, messageid] = mkdir( Sim_Path ); % create empty simulation folder

WriteOpenEMS( [Sim_Path '/' Sim_CSX], FDTD, CSX );
CSXGeomPlot( [Sim_Path '/' Sim_CSX] );
RunOpenEMS( Sim_Path, Sim_CSX, '--engine=multithreaded --numThreads=1');

%% post-processing
close all
f = linspace( 1e6, f_max, 1601 );
port = calcPort( port, Sim_Path, f, 'RefImpedance', 50);

s11 = port{1}.uf.ref./ port{1}.uf.inc;
s21 = port{2}.uf.ref./ port{1}.uf.inc;

plot(f/1e9,20*log10(abs(s11)),'k-','LineWidth',2);
hold on;
grid on;
plot(f/1e9,20*log10(abs(s21)),'r--','LineWidth',2);
legend('S_{11}','S_{21}');
ylabel('S-Parameter (dB)','FontSize',12);
xlabel('frequency (GHz) \rightarrow','FontSize',12);
ylim([-40 2]);

