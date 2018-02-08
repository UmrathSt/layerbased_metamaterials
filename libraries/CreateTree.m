function [CSX, params] = CreateTree(CSX, object, translate, rotate)

  if !(nargin == 4);
    display("Falsche Parameterzahl für CreatePlus");
  end; 
  L1 = object.L1;
  L2 = object.L2;
  w1 = object.w1;
  lz = object.lz;
  tx = object.tx;
  ty = object.ty;
  UClx = object.UClx;
  UCly = object.UCly;
  translate = object.translate;
  rotate = object.rotate;
  upper_start = [-L1/2, -w/2, -lz/2];
  upper_stop =  [+L1/2, w, +lz/2];
  start1 = [-L2/2, L1/4-w1/2, -lz/2];
  stop1  = [+L2/2, L1/4+w1/2, +lz/2];
  start2 = start1 - [0, L1/2, 0];
  stop2  = stop1  - [0, L1/2, 0];
  for trans_x = [tx, -tx];
    for trans_y = [ty, -ty];
      translate = [trans_x, trans_y, 0];
      CSX = AddBox(CSX, object.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Rotate_Z', pi/2+rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.name, object.prio+1, start1, stop1, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.name, object.prio+1, start2, stop2, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.name, object.prio+1, start1, stop1, 'Transform', {'Rotate_Z', rotate+pi/2, 'Translate', translate});
      CSX = AddBox(CSX, object.name, object.prio+1, start2, stop2, 'Transform', {'Rotate_Z', rotate+pi/2, 'Translate', translate});
    end;
  end;

  ocenter = [object.xycenter, 0] + translate;
  params = ["# tree-patch made of "  object.material.name " L, w, lz = " num2str(object.L) ", " num2str(object.w) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction