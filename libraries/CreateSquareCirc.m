function [CSX, params] = CreateSquareCirc(CSX, object, translate, rotate);
  object = object;
  diag1 = [object.L1/2, object.L1/2, object.lz/2];
  box1_start = -diag1;
  box1_stop = +diag1;
  CSX = AddBox(CSX, object.material.name, object.prio, box1_start, box1_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  c1 = [0, 0, -object.lz/2];
  c2 = [0, 0, +object.lz/2];
  CSX = AddCylinder(CSX, object.bmaterial.name, object.prio+1, c1, c2, object.R1,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# square patch made of "  object.material.name " lx, ly, lz = " num2str(object.L1) ", " num2str(object.L1) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) \
            "# with circular hole of radius " num2str(object.R1) "\n"];
  return;
endfunction