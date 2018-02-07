function [CSX, params] = CreateDoubleHEXagon(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  L1 = object.Lhex1;
  w1 = object.whex1;
  L2 = object.Lhex2;
  w2 = object.whex2;
  UClx = object.UClx;
  UCly = object.UCly;
  prio = object.prio;
  h_start1 = [-L1/2, -L1*sqrt(3)/2, -object.lz/2];
  h_stop1 = [L1/2, -L1*sqrt(3)/2+w1, object.lz/2];
  h_start2 = [-L2/2, -L2*sqrt(3)/2, -object.lz/2];
  h_stop2 = [L2/2, -L2*sqrt(3)/2+w2, object.lz/2];
  hexmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
  bstart = [-UClx/2, -UCly/2, -object.lz/2];
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
    bstart = [-UClx/2, -UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,...
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  
  grid_trans{1} = [0, 0, 0];
  grid_trans{2} = [UClx/2, UCly/2, 0];
  grid_trans{3} = [-UClx/2, UCly/2, 0];
  grid_trans{4} = -grid_trans{3};
  grid_trans{5} = -grid_trans{2};
  for ii = 1:numel(grid_trans);
    tt = grid_trans{ii};
    for rot = [0, 1, 2, 3, 4, 5]*pi/3;
      CSX = AddBox(CSX, hexmaterial, prio+1, h_start1, h_stop1, ...
          'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate+tt});
      CSX = AddBox(CSX, hexmaterial, prio+1, h_start2, h_stop2, ...
          'Transform', {'Rotate_Z', rotate+rot, 'Translate', translate+tt});
    end;
  end;
  
  
            
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# double Hexagonal grid of hexagons made of ',  hexmaterial, ' at center position x = ', num2str(ocenter(1)), ' y = ', num2str(ocenter(2)), ' z = ' num2str(ocenter(3)), '\n' ...
            '# edge length, width L1, w1=', num2str(L1,'%.5f') ', ' num2str(w1,'%.5f'), ' and L2, w2 =' num2str(L2) ', ' num2str(w2) ', background material ', bmaterial, '\n'];
  return;
end