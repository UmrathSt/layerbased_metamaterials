dump_TD = 1; % don't dump time-domain field-data 
show_geom = 0; % don't show the geometry on every run
angles =[0];%linspace(0, pi/4, 91);%linspace(0, pi/8, 46); % steps of 1 degree
freq = 20e9; % frequencies for which to obtain the RCS
Path = '/mnt/hgfs/E/openEMS/PECsphere_RCS_1-20GHz/';
L = 50; % mm
if strcmp(uname.nodename, 'Xeon');
    Path = '/media/stefan/Daten/openEMS/PECsphere_RCS_1-20GHz/' 
end;

physical_constants;

for i_alpha =1:1;
   clear -x c0 dump_TD show_geom angles i_alpha rcs_at_angles freq Path epsRe epsIm L;
   rcs = bistat_PECsphere_rcs(angles(i_alpha), freq, L, dump_TD, show_geom, Path);
   rcs_at_angles{i_alpha} = rcs;
end;




