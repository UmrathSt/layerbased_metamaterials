function val = doPortDump_optimize(port, UC, fcenter, fwidth);
% Do a dump of S11 and return a value which corresponds to
% the sum of the magnitudes of S11 at given center frequencies
% fcenter with corresponding widths fwidth, where both are 1d arrays
  if UC.s_dumps;
    try;
      port = dumpS11(port, UC);
      tmp = 0;
      nfc = numel(fcenter);
      nfw = numel(fwidth);
      assert(numel(fcenter) == numel(fwidth), ['fcenter has to be as long as fwidth, got lengths ', nfc, nfw]);
      absS11 = abs(port{1}.uf.ref ./ (port{1}.uf.inc));
      f = port{1}.f;
      for i = numel(fcenter);
          a = fcenter(i)-fwidth(i)/2;
          b = fcenter(i)+fwidth(i)/2;
          tmp = tmp + integrate_interval(f, absS11, a, b);
          display(['i=', num2str(i)]);
          display(['tmp = ', num2str(tmp)]);
      end;
      val = tmp;
    catch lasterror;
      msg = lasterror.message;
      fprintf("Fehler beim Port dump!!!: %s", msg);
    end;
  end;
  return;
  end