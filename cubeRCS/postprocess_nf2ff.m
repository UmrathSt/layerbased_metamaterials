function postprocess_nf2ff(Sim_Path, f, theta, theta_off, phi, phi_off, paramstr, Mirror= {1, 'PMC', 0})
   % read nf2ff_structure in directory 'Path', and calculate nf2ff
   % data at frequency f at angles theta, phi in radian
   physical_constants;
   E_dir = [cos(theta_off), 0, -sin(theta_off)];
   for F = f;
    EF = ReadUI( 'et', Sim_Path, F ); % time domain/freq domain voltage
    Pin = 0.5*norm(E_dir)^2/Z0 .* abs(EF.FD{1}.val).^2;
    load([Sim_Path 'nf2ff_struct.dat']);
    nf2ff = CalcNF2FF(nf2ff, Sim_Path, F, theta+theta_off, phi+phi_off, 'Mode',1, 'Mirror', Mirror);
    rcs = 4*pi*nf2ff.P_rad{1}./Pin(1);
    rcs_fname =  strcat('rcs_f_', num2str(f/1e9), '_GHz.dat');
    fid = fopen(rcs_fname, 'wt');
    fprintf(fid, ['# ' paramstr '\n']);
    th0 = theta(1)
    thend = theta(end);
    th_size = length(theta);
    ph0 = phi(1)
    phend = phi(end);
    ph_size = size(phi);
    fprintf(fid, ['# frequency f = ' num2str(F/1e9) ' GHz, theta=linspace('num2str(th0) ',' num2str(thend) ',' num2str(th_size) '\n']);
    fprintf(fid, ['# phi=linspace('num2str(ph0) ',' num2str(phend) ',' num2str(ph_size) '\n']);
    fclose(fid);
    dlmwrite(rcs_fname, rcs, 'delimiter', ', ', '-append');
  end;
  end
    
    