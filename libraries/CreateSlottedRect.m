function [CSX, params] = CreateSlottedRect(CSX, object, translate, rotate);
% Broadband absorber geometry of
% 2015 IEEE International Microwave and RF Conference (IMaRC) 
  UClx = object.UClx;
  UCly = object.UCly;
  L1 = object.L1;
  w1 = object.w1;
  L2 = object.L2;
  w2 = object.w2;
  L3 = object.L3
  gap2_op = 1;
  try;
    gap2_op = object.gap2_op;
  catch lasterror;
  end;

  gap  = object.gap;
  lz = object.lz;
  material = object.material.name;
  bmaterial = object.bmaterial.name;
 
  inner1 = [-L3/2, -L3/2, -lz/2];
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
  
  louter1 = [-L1/2, -L1/2, -lz/2];
  louter2 = [+L1/2, -L1/2+w1, lz/2];
  CSX = AddBox(CSX, material, object.prio+1,...
        louter1, louter2, 'Transform', {'Translate', translate,'Rotate_Z', rotate});
  CSX = AddBox(CSX, material, object.prio+1,...
        louter1, louter2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+pi/2});
  souter1 = [-L1/2, L1/2, -lz/2];
  souter2 = [L2/2, L1/2-w2, lz/2];        
  CSX = AddBox(CSX, material, object.prio+1,...
        souter1, souter2, 'Transform', {'Translate', translate,'Rotate_Z', rotate});
  souter1 = [-L1/2, L1/2, -lz/2];
  souter2 = [-L1/2+w2, -L2/2, lz/2];        
  CSX = AddBox(CSX, material, object.prio+1,...
        souter1, souter2, 'Transform', {'Translate', translate,'Rotate_Z', rotate});


    
  CSX = AddBox(CSX, material, object.prio+1,...
        inner1, inner2, 'Transform', {'Translate', translate,'Rotate_Z', rotate});

  
  % now add the gaps
  gstart1 = [-sqrt(2)*gap/2, (L1-w2-L3)/sqrt(2), -lz/2];
  gstop1  = [+sqrt(2)*gap/2,-(L1-L3)/4-w2/2, +lz/2];

  CSX = AddBox(CSX, material, object.prio+2, gstart1, gstop1, ...
        'Transform', {'Rotate_Z', pi/4, 'Translate', translate+[-(L1-w1+L2)/4+w2,(L1-w1+L2)/4-w2,0]}); 
  gstart2 = [-sqrt(2)*gap/2, (L1-L3)/4+w1/2, -lz/2];
  gstop2  = [+sqrt(2)*gap/2,-(L1-w1-L3)/sqrt(2), +lz/2];
  CSX = AddBox(CSX, material, object.prio+2, gstart1, gstop1, ...
        'Transform', {'Rotate_Z', pi/4, 'Translate', translate+[(L1-w1+L2)/4-w1,-(L1-w1+L2)/4+w1,0]}); 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# broadband double-rect absorber made of ',  material, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# edge lengths L1, w1=', num2str(L1,'%.4f') ', ' num2str(w1,'%.4f'), 'edge lengths L2, w2=', num2str(L2,'%.4f') ', ' num2str(w2,'%.4f'), ' inner rect L=', num2str(L3,'%.4f'), ', ', ', gap =' num2str(gap, '%.4f'), ', background material ', bmaterial, '\n'];
  return;
end