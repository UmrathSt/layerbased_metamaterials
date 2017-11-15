function doPortDump(port, UC);
  if UC.s_dumps;
    try;
      dumpS11(port, UC);
    catch lasterror;
      msg = lasterror.message;
      fprintf("Fehler: %s", msg);
    end;
    end;
  end