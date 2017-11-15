function [CSX, params] = CreateCrissCross(CSX, object, translate, rotate)

  if !(nargin == 4);
    display("Falsche Parameterzahl für CreatePlus");
  end; 
  L = object.L;
  w = object.w;
  lz = object.lz;
  UClx = object.UClx;
  UCly = object.UCly;
  upper_start = [-L/2, L, -lz/2];
  upper_stop =  [+L/2, L-w, +lz/2];
  left_start =  [-L/2, -w, -lz/2];
  left_stop  =  [-L/2+w, L, lz/2];
  right_start =  [L/2, -w, -lz/2];
  right_stop  =  [L/2-w, L, lz/2];
  
  alpha = [0, pi/2, pi, 3*pi/2];
  translation = [[0, L/2, 0]; [-L/2, 0, 0]; [0, -L/2, 0]; [L/2, 0, 0]];
  start = [-UClx/2, -UCly/2, -lz/2];
  stop  = -start;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, start, stop,
                'Transform',{'Rotate_Z', rotate, 'Translate', translate});
  for i = 1:4;
      rot = rotate + alpha(i);
      trans = translate + translation(i,:);
      CSX = AddBox(CSX, object.material.name, object.prio+1, upper_start, upper_stop, 
          'Transform',{'Rotate_Z', rot, 'Translate', trans});
      CSX = AddBox(CSX, object.material.name, object.prio+1, left_start, left_stop, 
          'Transform',{'Rotate_Z', rot, 'Translate', trans});
      CSX = AddBox(CSX, object.material.name, object.prio+1, right_start, right_stop, 
          'Transform',{'Rotate_Z', rot, 'Translate', trans});
  endfor;
  
  ocenter = [object.xycenter, 0] + translate;
  params = ["# +-patch made of "  object.material.name " L, w, lz = " num2str(object.L) ", " num2str(object.w) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction