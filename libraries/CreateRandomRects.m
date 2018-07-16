function [CSX, params, mesh_lines] = CreateRandomRects(CSX, object, translate, rotate);
  % Create Cu rectangles of edge length L at positions
  % given by object.centers for all points in object.centers
  diag = [object.UClx/2, object.UCly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  bmaterial = 'air';
  L = object.L;
  [CSX, params] = defineMaterial(CSX, object.material, '');
  mesh_lines.x = [];
  mesh_lines.y = [];
  mesh_lines.z = [0];
  try;
    bmaterial = object.bmaterial.name;
    [CSX, params] = defineMaterial(CSX, object.material, '');
    bstart = [object.UClx/2, object.UCly/2, -object.lz/2];
    bstop  = [-object.UClx/2, -object.UCly/2, object.lz/2];
    CSX = AddBox(CSX, bmaterial.name, object.prio+1, bstart, bstop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  catch lasterror;
  end;
  for i = 1:size(object.centers)(1);
      box_start = [object.centers(i,:)-L/2, -object.lz/2];
      box_stop  = [object.centers(i,:)+L/2, +object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  
  CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# random rect patches made of '  object.material.name '. center coordinates' mat2str(object.centers) '\n'...
            '# filling factor is ' num2str(size(object.centers)(1)*object.L/(object.UClx*object.UCly)) ' percent \n' ...
            '# background material (if any) is ' bmaterial '\n'];
  return;
end