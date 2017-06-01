function [port] = dumpS11(port, UC);
  freq = linspace(UC.f_start, UC.f_stop, round((UC.f_stop-UC.f_start)/UC.s11_delta_f));
  Sim_Path = UC.SimPath;
  s11_filename_prefix = UC.s11_filename_prefix;
  s11_filename = UC.s11_filename;
  s11_subfolder = UC.s11_subfolder;
  params = UC.param_str;
  port{1} = calcPort(port{1}, Sim_Path, freq, 'RefImpedance', 376.73);#, 'RefImpedance', 130
  port{2} = calcPort(port{2}, Sim_Path, freq, 'RefImpedance', 376.73);#, 'RefImpedance', 130
  Z1 = port{1}.uf.tot ./ port{1}.if.tot;
  s11 = port{1}.uf.ref ./ (port{1}.uf.inc);
  Z2 = port{2}.uf.tot ./ port{2}.if.tot;
  s22 = port{2}.uf.ref ./ (port{2}.uf.inc);
  s21 = port{2}.uf.inc./port{1}.uf.inc;
  U1 = port{2}.uf.tot;
  I1 = port{2}.if.tot;
  s11_filename = ['S_f_' s11_filename_prefix '.txt'];
  s_folder = ["./SParameters/" s11_subfolder];
  if not(exist(s_folder, "dir"));
    display("Folder for S11 output did not exist. Calling mkdir...");
    mkdir(s_folder);
  else;
    display("Folder for S11 output found.");
  endif;
  outfile = fopen([s_folder "/" s11_filename], 'w+');
  fprintf(outfile, [params]);
  fprintf(outfile, "# Re/Im parts of the scattering parameters S11 (refl.) and S21 (transm.) as a function of frequency \n");
  fprintf(outfile, "# first column is frequency, second and third columns are Re/Im of S11 and S21, respectively.\n");
  fprintf(outfile, "# Parameters of Metamaterial are: \n");
  for i=1:size(s11)(2);
      fprintf(outfile, '%f, %f, %f, %f, %f ', freq(1, i), real(s11(1, i)), imag(s11(1,i )), real(s21(1,i )), imag(s21(1,i )));
      fprintf(outfile, '\n');
  end;
  fclose(outfile);
  return;
endfunction