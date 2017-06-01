function doPortDump(port, UC);
  if UC.s_dumps;
    try;
      dumpS11(port, UC);
    catch
      msg = lasterror.message;
      printf("Fehler: %s", msg);
    end_try_catch;
  endif;
endfunction;