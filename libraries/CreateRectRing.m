function [CSX, params] = CreateRectRing(CSX, object, translate, rotate);
  object = object;
  L = object.Lr;
  w = object.wr;
  lr = object.lr;
  lx = object.lx;
  ly = object.ly;
  
  bar_start = [L/2, -L/2, object.lz/2];
  bar_stop  = [L/2-w, L/2-w, -object.lz/2];
  res_start = [L/2, lr/2, object.lz/2];
  res_stop  = [L/2-w, -lr/2, -object.lz/2];
  for alpha = [0, pi/2, pi, 3*pi/2];
    CSX = AddBox(CSX, object.material.name, object.prio+1, bar_start, bar_stop,
         'Transform', {'Rotate_Z', rotate+alpha, 'Translate', translate});
    CSX = AddBox(CSX, object.resmaterial.name, object.prio+2, res_start, res_stop,
         'Transform', {'Rotate_Z', rotate+alpha, 'Translate', translate});
  end;
  diag = [lx/2, ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# rectring patch L, w = " num2str(L) ", " num2str(w) " made of "  object.material.name "in background material" object.bmaterial.name ". lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
end