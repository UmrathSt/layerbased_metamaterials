function [CSX, params] = CreatePlusVias(CSX, object, translate, rotate)

  if !(nargin == 4);
    display("Falsche Parameterzahl für CreatePlusVias");
  end; 
  L = object.L;
  w = object.w;
  lz = object.lz;
  R = object.R;
  vias_lz = object.vias_lz;
  UClx = object.UClx;
  UCly = object.UCly;
  upper_start = [-L/2, -w/2, -lz/2];
  upper_stop =  [+L/2, +w/2, +lz/2];
  cstart = [0, 0, -lz/2];
  cstop  = [0, 0, lz/2+vias_lz];
  CSX = AddCylinder(CSX, object.material.name, object.prio+1, cstart, cstop, R, 'Transform', {'Translate', translate});
  start = [-UClx/2, -UCly/2, -lz/2];
  stop = -start;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, start, stop, 'Transform', {'Translate', translate});
  %CSX = AddBox(CSX, object.material.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+pi/4});
  %CSX = AddBox(CSX, object.material.name, object.prio+1, upper_start, upper_stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+3*pi/4});
  ring_start = [0, 0, -lz/2];
  ring_stop  = [0, 0, lz/2];
  % Versuch...
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, ring_start, ring_stop, L/2-w/2, w, 'Transform', {'Translate', translate});

  ocenter = [object.xycenter, 0] + translate;
  params = ["# +-patch with vias made of "  object.material.name " L, w, lz = " num2str(object.L) ", " num2str(object.w) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
end