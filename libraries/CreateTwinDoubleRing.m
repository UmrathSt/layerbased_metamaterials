function [CSX, params] = CreateTwinDoubleRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, 
        ring_start, ring_stop, R1-w1/6, w1/6,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, 
        ring_start, ring_stop, R1-3*w1/6, w1/6,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, 
        ring_start, ring_stop, R2-w2/6, w2/6,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, object.material.name, object.prio+1, 
        ring_start, ring_stop, R2-3*w2/6, w2/6,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular twin-rings made of "  object.material.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) "\n"];
  return;
endfunction