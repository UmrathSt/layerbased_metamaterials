function [CSX, params] = CreateDoubleRingPlus(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w1;
  L1 = object.L1;
  L2 = object.L2;
  UClx = object.UClx;
  UCly = object.UCly;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  p1start = [-L1/2, -w1/2, -object.lz/2];
  p1stop  = -p1start;
  p2start = [-w1/2, L1/2, -object.lz/2];
  p2stop  = -p2start;

  p3start = [-L2/2, -w1/2, -object.lz/2];
  p3stop  = -p3start;
  p4start = [-w1/2, 1.1*L2/2, -object.lz/2];
  p4stop  = -p4start;
  
  ringmaterial = object.material.name;
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
    ringmaterial = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  CSX = AddBox(CSX, ringmaterial, object.prio+1,...
        p1start, p1stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, ringmaterial, object.prio+1,...
        p2start, p2stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, ...
        ring_start, ring_stop, R1-w1/2, w1,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  for trans_x = [UClx/2, -UClx/2];
    for trans_y = [UCly/2, -UCly/2];
      trans = [trans_x, trans_y, 0];
      CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, ...
        ring_start, ring_stop, R2-w2/2, w2,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate+trans});
      end;
    end;
  tt = [UClx/2, 0, 0];

  for rot = (0:3)*pi/2;
    CSX = AddBox(CSX, ringmaterial, object.prio+1,...
        p3start, p3stop, 'Transform', {'Translate', translate+tt,'Rotate_Z', rotate+rot});
    CSX = AddBox(CSX, ringmaterial, object.prio+1,...
        p4start, p4stop, 'Transform', {'Translate', translate+tt,'Rotate_Z', rotate+rot});
  end; 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# circular rings made of ',  ringmaterial, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# radius R1, R2=', num2str(R1,'%.10f') ', ' num2str(R2,'%.10f'), ' ringwidths w1, w2=', num2str(w1,'%.10f'), ', ', num2str(w2,'%.10f'), ', background material ', bmaterial, '\n'];
  return;
end