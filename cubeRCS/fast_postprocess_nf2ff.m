function nf2ff = fast_postprocess_nf2ff(nf2ff_struct_Path, Sim_Path, f, theta, theta_off, phi, phi_off, paramstr,  namestr, Mirror= {1, 'PMC', 0})
   % read nf2ff_structure in directory 'Path', and calculate nf2ff
   % data at frequency f at angles theta, phi in radian
   physical_constants;
   E_dir = [cos(theta_off), 0, -sin(theta_off)];
   EF = ReadUI('et', Sim_Path, f);
   Pin = 0.5*norm(E_dir)^2/Z0 .* abs(EF.FD{1}.val).^2;
    load([nf2ff_struct_Path 'nf2ff_struct.dat']);
    nf2ff = CalcNF2FF(nf2ff, Sim_Path, f, theta+theta_off, phi+phi_off, 'Mode',1, 'Mirror', Mirror);
    fprintf('Prad{1} \n');
    nf2ff.P_rad{1}
    fprintf('Pin(1) \n');
    Pin(1)
   for Fn = 1:numel(f);
    
    rcs = 4*pi*nf2ff.P_rad{Fn}./Pin(Fn);
    rcs_fname =  strcat('rcs_', namestr, '_f_', num2str(f(Fn)/1e9,'%.2f'), '_GHz.dat');
    fid = fopen(rcs_fname, 'wt');
    fprintf(fid, ['# ' paramstr '\n']);
    th0 = theta(1);
    thend = theta(end);
    th_size = length(theta);
    ph0 = phi(1);
    phend = phi(end);
    ph_size = length(phi);
    fprintf(fid, ['# frequency = ' num2str(f(Fn)/1e9) ' GHz, \n']);
    fprintf(fid, ['# lines are varying theta, columns varying phi \n']);
    fprintf(fid, ['# theta = linspace(' num2str(th0) ', ' num2str(thend) ', ' num2str(th_size) ')\n']);
    fprintf(fid, ['# phi = linspace(' num2str(ph0) ', ' num2str(phend) ', ' num2str(ph_size) ')\n']);
    fclose(fid);
    dlmwrite(rcs_fname, rcs, 'delimiter', ', ', '-append');
  end;
  end
    
    