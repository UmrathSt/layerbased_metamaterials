function [CSX, params] = CreateHEXagon(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  L1 = object.L1;
  w1 = object.w1;
  UClx = object.UClx;
  UCly = object.UCly;
  prio = object.prio;
  h_start = [-L/2, -L*sqrt(3)/2, -object.lz/2];
  h_stop = [L/2, -L*sqrt(3)/2+w, object.lz/2];
  hexmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
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
    hexmaterial = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  
  for rot = [0, 1, 2, 3, 4, 5]*pi/3;
    CSX = AddBox(CSX, hexmaterial, prio+1, h_start, h_stop, ...
        'Transform'., {'Rotate_Z', rotate+rot, 'Translate', translate});
  end;
  
  
            
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# Hexagonal grid of hexagons made of ',  hexmaterial, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# edge length, width L1, w1=', num2str(L1,'%.5f') ', ' num2str(w1,'%.5f'), ', background material ', bmaterial, '\n'];
  return;
end