function [CSX, params] = CreateResistiveDoubleRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
  lz = object.lz;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
  resistormaterial = object.resistor.name;
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  if object.complemential;
    try;
    CSX = AddMaterial(CSX, 'air');
    CSX = SetMaterialProperty(CSX, 'air', 'Epsilon', 1);
    catch lasterror;
    end;
    ringmaterial = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  
  g1 = [R1, -w1/2, -lz/2];
  g2 = [R1-w1, w1/2, lz/2];
  g3 = [R2-w2, -w2/2, -lz/2];
  g4 = [R2, w2/2, lz/2];
  for rot = (0:3)*pi/2+pi/4;
    CSX = AddBox(CSX, resistormaterial, object.prio+3, g1, g2, ...
    'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});
    CSX = AddBox(CSX, resistormaterial, object.prio+3, g3, g4, ...
    'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate});
  end;
  
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, ...
        ring_start, ring_stop, R1-w1/2, w1,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, ...
        ring_start, ring_stop, R2-w2/2, w2,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# circular resistive rings made of ',  ringmaterial, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# radius R1, R2=', num2str(R1,'%.10f') ', ' num2str(R2,'%.10f'), ' ringwidths w1, w2=', num2str(w1,'%.10f'), ', ', num2str(w2,'%.10f'), ', background material ', bmaterial, '\n'];
  return;
end