function [CSX, params] = CreateFractal(CSX, object, translate, rotate);
  object = object;
  dLshift = object.dLshift;
  UClx = object.UClx;
  UCly = object.UCly;
  for angle = [0, pi/2, pi, 3*pi/2];
      box_start = [-object.L/2,object.L/2,-object.lz/2];
      box_stop  = [-object.L/6,object.L/2-object.dL,+object.lz/2];
      rotate = angle;
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
             'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      box_start = [object.L/2,object.L/2,-object.lz/2];
      box_stop  = [object.L/6,object.L/2-object.dL,+object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
             'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      box_start = [-object.L/6,object.L/2-dLshift,-object.lz/2];
      box_stop  = [object.L/6,object.L/2-object.dL-dLshift,+object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
             'Transform', {'Rotate_Z', rotate, 'Translate', translate});
             
      # vertical lines
      box_start = [-object.L/6-object.dL/2,object.L/2,-object.lz/2];
      box_stop  = [-object.L/6+object.dL/2,object.L/2-dLshift-object.dL,+object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
             'Transform', {'Rotate_Z', rotate, 'Translate', translate});  
      box_start = [object.L/6+object.dL/2,object.L/2,-object.lz/2];
      box_stop  = [object.L/6-object.dL/2,object.L/2-dLshift-object.dL,+object.lz/2];
      CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
             'Transform', {'Rotate_Z', rotate, 'Translate', translate});  
  end;
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# fractal patch made of '  object.material.name '. L = ' num2str(object.L) ', ' num2str(object.lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'];
  return;
end