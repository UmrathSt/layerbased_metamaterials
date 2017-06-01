function [s11, freq] = doPortDump_return_s11(port, UC);
  if UC.s_dumps;
    try;
      [port, s11, freq] = dump_and_return_S11(port, UC);
    catch
      msg = lasterror.message;
      printf("Fehler: %s", msg);
    end_try_catch;
  endif;
  return;
endfunction;