function [CSX, params] = CreateRectangle(CSX, object, translate, rotate);
  object = object;
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  CSX = AddBox(CSX, object.material.name, object.prio+1, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  diag = [object.UClx/2, object.UCly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# rect patch made of "  object.material.name "in background material" object.bmaterial.name ". lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction