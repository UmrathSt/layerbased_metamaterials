function [CSX, params] = CreateSlottedRect(CSX, object, translate, rotate);
  object = object;
  diag1 = [object.L1/2, object.L1/2, object.lz/2];
  box1_start = -diag1;
  box1_stop = +diag1;
  gap = object.gap;
  w = object.w;
  L1 = object.L1;
  box2_start = [-object.L1/sqrt(2)+gap, object.w/2, object.lz/2];
  box2_stop =  [0.75*object.L1, -object.w/2, -object.lz/2];
  CSX = AddBox(CSX, object.material.name, object.prio, box1_start, box1_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});

  CSX = AddBox(CSX, object.bmaterial.name, object.prio+1, box2_start, box2_stop,
         'Transform', {'Rotate_Z', rotate+pi/4, 'Translate', translate});

  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# squares patch made of '  object.material.name '. Dimension is ' num2str(L1) 'x' num2str(L1) ' and an air gap of width w=' num2str(w) ' mm is added, leaving only a ' num2str(gap) ' mm gap \n'];
  return;
endfunction