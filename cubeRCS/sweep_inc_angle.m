dump_TD = 0; % don't dump time-domain field-data 
show_geom = 0; % don't show the geometry on every run
angles = linspace(0, pi/4, 91);%linspace(0, pi/8, 46); % steps of 1 degree
freq = 92.5e9; % frequencies for which to obtain the RCS
Path = '/mnt/hgfs/E/openEMS/PVC_RCS/';
L = 50; % mm
if strcmp(uname.nodename, 'Xeon');
    Path = '/media/stefan/Daten/openEMS/cube_RCS/' 
end;
# Messergebnisse: 2.76574	0.03467
epsRe = 2.7657; % two possible values (according to the comparison with monostatic measured data
epsIm = 0.03467; % are a real part of 2.71 or 2.795 for the permittivity
physical_constants;

for i_alpha = [46];%80:numel(angles);
   clear -x c0 dump_TD show_geom angles i_alpha rcs_at_angles freq Path epsRe epsIm L;
   rcs = bistat_cube_rcs(angles(i_alpha), freq, L, epsRe, epsIm, dump_TD, show_geom, Path);
   rcs_at_angles{i_alpha} = rcs;
   #dump_rcsF_to_file(rcs, freq, angles(i_alpha), ['bistrcs_PVC_' num2str(i_alpha) '_eps_2.7657_nf2ff.dat'], ['# RCS of a L=' num2str(L) ' mm dielectric cube, eps_r=' num2str(epsRe) '+i' num2str(epsIm)] );
end;




