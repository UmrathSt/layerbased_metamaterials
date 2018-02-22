function [CSX, params] = CreateRect(CSX, object, translate, rotate);
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  bmaterial = 'air';
  try;
    bmaterial = object.bmaterial.name;
    bstart = [object.UClx/2, object.UCly/2, -object.lz/2];
    bstop  = [-object.UClx/2, -object.UCly/2, object.lz/2];
    CSX = AddBox(CSX, bmaterial, object.prio+1, bstart, bstop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  catch lasterror;
  end;
  
  CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# rect patch made of '  object.material.name '. lx, ly, lz = ' num2str(object.lx) ', ' num2str(object.ly) ', ' num2str(object.lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'...
            '# background material (if any) is ' bmaterial '\n'];
  return;
end