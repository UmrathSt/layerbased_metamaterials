function [CSX, params] = CreateSquares(CSX, object, translate, rotate);
  object = object;
  diag1 = [object.lx1/2, object.ly1/2, object.lz/2];
  box1_start = -diag1;
  box1_stop = +diag1;
  diag2 = [object.lx2/2, object.ly2/2, object.lz/2];
  box2_start = -diag2;
  box2_stop = +diag2;
  CSX = AddBox(CSX, object.material.name, object.prio, box1_start, box1_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  for xc = [object.lx1/2, -object.lx1/2];
    for yc = [object.ly1/2, -object.ly1/2];
      CSX = AddBox(CSX, object.material.name, object.prio, box2_start, box2_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate + [xc, yc, 0]});
    endfor;
  endfor; 
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# squares patch made of '  object.material.name ' lx, ly, lz = ' num2str(object.lx1) ', ' num2str(object.ly1) ', ' num2str(object.lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'];
  return;
endfunction