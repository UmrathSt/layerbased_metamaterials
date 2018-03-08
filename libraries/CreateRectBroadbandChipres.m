function [CSX, params] = CreateRectBroadbandChipres(CSX, object, translate, rotate);
% Broadband absorber geometry of
% : Appl. Phys. Lett.112, 021605 (2018); doi: 10.1063/1.5004211 
% modified for rectangle instead of circle

  UClx = object.UClx;
  UCly = object.UCly;
  L = object.L;
  R = object.R;
  reswidth = object.reswidth;
  gapwidth = object.gapwidth;
  s = object.s;
  dphi = pi/4;
  try;
    dphi = object.dphi;
  catch lasterror;
  end;
  
  lz = object.lz;
  material = object.material.name;
  bmaterial = object.bmaterial.name;
  resistormaterial = object.resistormaterial.name;
  gap1 = [+gapwidth/2, -gapwidth/2, -lz/2];
  gap2 = [R, +gapwidth/2, +lz/2];
  irect1 = [-s/2, -s/2, -lz/2];
  irect2 = [s/2, s/2, lz/2];

  
  resistor1 = [L, -gapwidth/2, -lz/2];
  resistor2 = [L+reswidth, gapwidth/2, lz/2];

  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Translate', translate});
  CSX = AddBox(CSX, material, object.prio+4, irect1, irect2,...
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  if object.complemential;
    try;
    CSX = AddMaterial(CSX, 'air');
    CSX = SetMaterialProperty(CSX, 'air', 'Epsilon', 1);
    catch lasterror;
    end;
    material = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  CSX = AddBox(CSX, material, object.prio, [-R,-R,-lz/2],[R,R,lz/2], ...
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});

  for rot = (0:3)*pi/2+dphi;
    CSX = AddBox(CSX, bmaterial, object.prio+1,...
        gap1, gap2, 'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});
    CSX = AddBox(CSX, resistormaterial, object.prio+2, resistor1, resistor2,'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});

  end;

    
 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# broadband chipresonator absorber made of ',  material, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n'];
  return;
end