function [CSX, params] = CreateBroadbandRect(CSX, object, translate, rotate);
% Broadband absorber geometry of
% 2015 IEEE International Microwave and RF Conference (IMaRC) 
  UClx = object.UClx;
  UCly = object.UCly;
  L1 = object.L1;
  w1 = object.w1;
  L2 = object.L2;

  gap  = object.gap;
  lz = object.lz;
  material = object.material.name;
  bmaterial = object.bmaterial.name;
  outer1 = [-L1/2, -L1/2, -lz/2];
  outer2 = [+L1/2, -L1/2+w1, lz/2];
  inner1 = [-L2/2, -L2/2, -lz/2];
  inner2 = -inner1;

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
    material = 'air';
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  

  for rot = (0:3)*pi/2;
    CSX = AddBox(CSX, material, object.prio+1,...
        outer1, outer2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot});
  end;
    
  CSX = AddBox(CSX, material, object.prio+1,...
        inner1, inner2, 'Transform', {'Translate', translate,'Rotate_Z', rotate});

  
  % now add the gap
  gstart = [-sqrt(2)*gap/2, (L1-L2)/4+w1, -lz/2];
  gstop  = [+sqrt(2)*gap/2,-(L1-L2)/4, +lz/2];
  CSX = AddBox(CSX, material, object.prio+2, gstart, gstop, ...
        'Transform', {'Rotate_Z', pi/4, 'Translate', translate+[-L1/4+w1/4,L1/4-w1/4,0]}); 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# broadband rect absorber made of ',  material, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# edge lengths L1, w1=', num2str(L1,'%.4f') ', ' num2str(w1,'%.4f'), ' inner rect L=', num2str(L2,'%.4f'), ', ', ', gap =' num2str(gap), ', background material ', bmaterial, '\n'];
  return;
end