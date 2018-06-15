dump_TD = 0; % don't dump time-domain field-data 
show_geom = 0; % don't show the geometry on every run
angles =[0];%linspace(0, pi/4, 91);%linspace(0, pi/8, 46); % steps of 1 degree
freq =20e9; % frequencies for which to obtain the RCS
Path = '/mnt/hgfs/E/openEMS/PEC_sphereRCS_10-20/';
R = 50/2; % mm
if strcmp(uname.nodename, 'Xeon');
    Path = '/media/stefan/Daten/openEMS/sphere_RCS/' 
end;

physical_constants;

for i_alpha =1:1;
   clear -x c0 dump_TD show_geom angles i_alpha rcs_at_angles freq Path epsRe epsIm R;
   rcs = bistat_PECsphere_rcs(angles(i_alpha), freq, R, dump_TD, show_geom, Path);
   rcs_at_angles{i_alpha} = rcs;
   #dump_rcsF_to_file(rcs, freq, angles(i_alpha), ['bistrcs_PVC_' num2str(i_alpha) '_eps_2.7657_nf2ff.dat'], ['# RCS of a L=' num2str(L) ' mm PEC cube, eps_r=' num2str(epsRe) '+i' num2str(epsIm)] );
end;




