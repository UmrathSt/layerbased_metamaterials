function [CSX, params] = CreatePlus(CSX, object, translate, rotate)

  if !(nargin == 4);
    display("Falsche Parameterzahl für CreatePlus");
  end; 
  L = object.L;
  w = object.w;
  lz = object.lz;
  UClx = object.UClx;
  UCly = object.UCly;
  translate = object.translate;
  rotate = object.rotate;
  upper_start = [-L/2, L, -lz/2];
  upper_stop =  [+L/2, L-w, +lz/2];
 
  CSX = AddBox(CSX, object.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, object.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Rotate_Z', pi/2+rotate, 'Translate', translate});

  
  ocenter = [object.xycenter, 0] + translate;
  params = ["# +-patch made of "  object.material.name " L, w, lz = " num2str(object.L) ", " num2str(object.w) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction