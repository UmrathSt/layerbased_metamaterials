function [CSX, params] = CreatePlus_and_doubleRing(CSX, object, translate, rotate)

  if !(nargin == 4);
    display('Falsche Parameterzahl für CreatePlus');
  end; 
  L = object.L;
  wL = object.wL;
  wR1 = object.wR1;
  wR2 = object.wR2;
  R1 = object.R1;
  R2 = object.R2;
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
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, rstart, rstop, R1-wR1/2, wR1,
  'Transform',{'Translate', translate});
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, rstart, rstop, R2-wR2/2, wR2,
  'Transform',{'Translate', translate});
  for i = 1:numel(alpha);
      rot = rotate + alpha(i);
      CSX = AddBox(CSX, object.material.name, object.prio+1, b_start, b_stop, 
          'Transform',{'Rotate_Z', rot, 'Translate', translate});

  end;
  
  ocenter = [object.xycenter, 0] + translate;
  params = ['# +-patch made of '  object.material.name ' L, wL, lz = ' num2str(L) ', ' num2str(wL) ', ' num2str(lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'];
  params = [params, '# Rings made of ' object.material.name '  R1, wR2, R2, wR2, lz = ' num2str(R1) ', ' num2str(wR1) ', ' num2str(R2) ', ' num2str(wR2) ', ' num2str(lz) ' at the same center as the plus patch. \n'];
  return;
end