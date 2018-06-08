function [CSX, params] = CreateOpenRect(CSX, object, translate, rotate);
% Broadband absorber geometry of
% 2015 IEEE International Microwave and RF Conference (IMaRC) 
  UClx = object.UClx;
  UCly = object.UCly;
  lz = object.lz;
  Ls = object.Ls;
  ws = object.ws;
  phis = object.phis;
  splits = object.splits;
  % consistency checks for the geometry
  assert(length(Ls) == length(splits));
  assert(length(Ls) == length(ws));
  assert(length(Ls) ==length(phis));
  bmaterial = object.bmaterial.name;
  material = object.material.name;
  

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
  
  for i = 1:length(Ls);
      rot = pi/2*i+phis(i);
      L = Ls(i);
      w = ws(i);
      split = splits(i);
      u1 = [-L/2, -L/2,   -lz/2];
      u2 = [L/2-split, -L/2+w, lz/2];
      r1 = [L/2,   L/2,  lz/2];
      r2 = [L/2-w, -L/2+split, -lz/2];
      l1 = [-L/2,   L/2,  lz/2];
      l2 = [-L/2+w, -L/2, -lz/2];
      o1 = [-L/2, L/2,   -lz/2];
      o2 = [L/2, L/2-w, lz/2];

      CSX = AddBox(CSX, material, object.prio+1,...
      u1, u2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot});
      CSX = AddBox(CSX, material, object.prio+1,...
      o1, o2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot});
      CSX = AddBox(CSX, material, object.prio+1,...
      l1, l2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot});
      CSX = AddBox(CSX, material, object.prio+1,...
      r1, r2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot});
      % add the connecting bar
      if i < length(Ls);
          barlength = ((L-w)/2-(Ls(i+1)-ws(i+1))/2)*sqrt(2)
          middle = ((L-w)/2+(Ls(i+1)-ws(i+1))/2)/sqrt(2); 
          s1 = [middle-barlength/2, w/2, -lz/2];
          s2 = [middle+barlength/2, -w/2, lz/2];
          CSX = AddBox(CSX, material, object.prio+1,...
          s1, s2, 'Transform', {'Translate', translate,'Rotate_Z', rotate+rot-3*pi/4});
      end;
  end;  

  
  % add a background material which cuts a rectangle from the inner square

  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# rect absorber made of ',  material, ' in background material ' bmaterial ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n'];
  for i = 1:length(Ls);
    params = strcat(params, ['# ' num2str(i) ': L, w, phi = ' num2str(Ls(i)) ', ' num2str(ws(i)) ', ' num2str(phis(i)) ' \n']);
  end;
  return;
end