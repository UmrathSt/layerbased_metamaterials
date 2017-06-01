function [port] = write_s11_f(port, Sim_Path, freq, params, f_start, f_stop, s11_filename_prefix, folder_postfix)
  port{1} = calcPort(port{1}, Sim_Path, freq, 'RefImpedance', 376.73);#, 'RefImpedance', 130
  port{2} = calcPort(port{2}, Sim_Path, freq, 'RefImpedance', 376.73);#, 'RefImpedance', 130
  Z1 = port{1}.uf.tot ./ port{1}.if.tot;
  s11 = port{1}.uf.ref ./ (port{1}.uf.inc);
  Z2 = port{2}.uf.tot ./ port{2}.if.tot;
  s22 = port{2}.uf.ref ./ (port{2}.uf.inc);
  s12 = port{2}.uf.ref./port{1}.uf.inc;
  U1 = port{2}.uf.tot;
  I1 = port{2}.if.tot;
  s11_filename = ['S_f_' s11_filename_prefix '_.txt'];
  s_folder = ["SParameters" folder_postfix];
  outfile = fopen([s_folder "/" s11_filename], 'w+');
  fprintf(outfile, "# Re/Im parts of the scattering parameters S11 (refl.) and S21 (transm.) as a function of frequency \n");
  fprintf(outfile, "# first column is frequency, second column is S11\n");
  fprintf(outfile, "# Parameters of Metamaterial are: \n");
  fprintf(outfile, ["# "  params "\n"]);
  for i=1:size(s11)(2);
      fprintf(outfile, '%f, %f, %f, %f, %f ', freq(1, i), real(s11(1, i)), imag(s11(1,i )), real(s12(1,i )), imag(s12(1,i )));
      fprintf(outfile, '\n');
  end;
  fclose(outfile);
  return;
endfunction