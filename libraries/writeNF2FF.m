function writeNF2FF(nf2ff, UC);
  SimPath = UC.SimPath;
  s11_subfolder = UC.s11_subfolder;
  nf2ff_folder = ["./ScatteringPatterns/" s11_subfolder];
  if not(exist(nf2ff_folder, "dir"));
    display("Folder for nf2ff output did not exist. Calling mkdir...");
    mkdir(nf2ff_folder);
  else;
    display("Folder for nf2ff output found.");
  endif;  
  
  for fqz = UC.dump_frequencies;
    thetarange = [0:2:360]*pi/180;
    phirange = [-180:2:180]*pi/180;
    nf2ff = CalcNF2FF(nf2ff, SimPath, fqz, thetarange, 
        phirange, 'Mode',1);

    % Write Antenna pattern to file
    E_far_normalized = nf2ff.E_norm{1}/max(max(nf2ff.E_norm{1}));
    DumpFF2VTK([nf2ff_folder '/Scattering_pattern_f_' num2str(fqz/1e9) '_GHz.vtk'],
        E_far_normalized,thetarange*180/pi, phirange*180/pi, 'scale', 1e-2);
  end;
endfunction;  