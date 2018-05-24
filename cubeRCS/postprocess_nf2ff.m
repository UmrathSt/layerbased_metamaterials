function postprocess_nf2ff(Sim_Path, f, theta, theta_off, phi, phi_off, Mirror= {1, 'PMC', 0})
   % read nf2ff_structure in directory 'Path', and calculate nf2ff
   % data at frequency f at angles theta, phi in radian
   physical_constants;
   E_dir = [cos(theta_off), 0, -sin(theta_off)];
   for F = f;
    EF = ReadUI( 'et', Sim_Path, F ); % time domain/freq domain voltage
    Pin = 0.5*norm(E_dir)^2/Z0 .* abs(EF.FD{1}.val).^2;
    theta = (0:1440)*pi/720;
    load([Sim_Path 'nf2ff_struct.dat']);
    nf2ff = CalcNF2FF(nf2ff, Sim_Path, F, theta+theta_off, phi+phi_off, 'Mode',1, 'Mirror', Mirror);
    rcs = 4*pi*nf2ff.P_rad{1}./Pin(1);
    rcs_name =  strcat('rcs_f_', num2str(f/1e9), '_GHz.dat');
    save rcs_name rcs;
  end;
  end
    
    