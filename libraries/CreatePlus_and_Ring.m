function [CSX, params] = CreatePlus_and_Ring(CSX, object, translate, rotate)

  if !(nargin == 4);
    display('Falsche Parameterzahl für CreatePlus');
  end; 
  L = object.L;
  wL = object.wL;
  wR = object.wR;
  R = object.R;
  lz = object.lz;
  UClx = object.UClx;
  UCly = object.UCly;
  b_start = [-L/2, -wL/2, -lz/2];
  b_stop =  [+L/2, wL/2, +lz/2];

  
  alpha = [0, pi/2];

  start = [-UClx/2, -UCly/2, -lz/2];
  stop  = -start;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, start, stop,
                'Transform',{'Rotate_Z', rotate, 'Translate', translate});
  rstart = [0, 0, -lz/2];
  rstop = -rstart;
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, rstart, rstop, R-wR/2, wR,
  'Transform',{'Translate', translate});
  for i = 1:numel(alpha);
      rot = rotate + alpha(i);
      CSX = AddBox(CSX, object.material.name, object.prio+1, b_start, b_stop, 
          'Transform',{'Rotate_Z', rot, 'Translate', translate});

  end;
  
  ocenter = [object.xycenter, 0] + translate;
  params = ['# +-patch made of '  object.material.name ' L, wL, lz = ' num2str(L) ', ' num2str(wL) ', ' num2str(lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'];
  params = [params, '# Ring made of ' object.material.name '  R, wR, lz = ' num2str(R) ', ' num2str(wR) ', ' num2str(lz) ' at the same center as the plus patch. \n'];
  return;
end