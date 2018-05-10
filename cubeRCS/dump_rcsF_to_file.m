function dump_rcsF_to_file(rcs, freq, angle, filename, param_string);
  % write the rcs data to a file called "filename"
  % and start the file by the string "param_string"
  % rcs is expected to be a structure containing
  % the rcs as a function of frequency for various angles
  % i. e. rcs{1} = RCS(freq) for angles(1),
  %       rcs{2} = RCS(freq) for angles(2),...
  outfile = fopen(filename, "w");
  fprintf(outfile, [param_string, "\n"]);
  fprintf(outfile, ['# RCS at f=' num2str(freq/1e9) ' GHz in m^2 as a function of the rotation angle around the y axis\n']);
  fprintf(outfile, ['# the columns in the following lines are the angle in rad and the monostatic RCS \n']);
  for i = 1:numel(angle);
    fprintf(outfile, '%f', angle);
    for j = 1:numel(rcs);
        fprintf(outfile, ', %f', rcs(j));
    end;
    fprintf(outfile, '\n');
  end;
  fclose(outfile);
  end