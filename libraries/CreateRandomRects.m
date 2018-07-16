function [CSX, params] = CreateRandomRects(CSX, object, translate, rotate);
  % Create Cu rectangles of edge length L at positions
  % given by object.centers for all points in object.centers
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  bmaterial = 'air';
  L = object.L;
  try;
    bmaterial = object.bmaterial.name;
    bstart = [object.UClx/2, object.UCly/2, -object.lz/2];
    bstop  = [-object.UClx/2, -object.UCly/2, object.lz/2];
    CSX = AddBox(CSX, bmaterial, object.prio+1, bstart, bstop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  catch lasterror;
  end;
  for i = 1:size(object.centers)(1);
      box_start = [object.center(i,:)-L/2, -object.lz/2];
      box_stop  = [object.center(i,:)+L/2, +object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  end;
  
  CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# random rect patches made of '  object.material.name '. center coordinates' mat2str(object.centers) '\n'...
            '# filling factor is ' num2str(size(object.centers)(1)*object.L/(object.lx*object.ly)) ' % \n' ...
            '# background material (if any) is ' bmaterial '\n'];
  return;
end