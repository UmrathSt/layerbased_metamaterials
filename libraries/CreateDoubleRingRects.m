function [CSX, params] = CreateDoubleRingRects(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
  rect1.wx = w1;
  rect1.wy = w1;
  rect1.lx = 2*R1;
  rect1.ly = 2*R1;
  rect1.lz = object.lz;
  rect2.wx = w2;
  rect2.wy = w2;
  rect2.lx = 2*R2;
  rect2.ly = 2*R2;
  rect2.lz = object.lz;
  rect1.material.name = object.material.name;
  rect2.material.name = object.material.name;
  rect1.prio = object.prio;
  rect2.prio = object.prio;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  if object.complemential;
    CSX = AddMaterial(CSX, "air");
    CSX = SetMaterialProperty(CSX, "air", "Epsilon", 1);
    ringmaterial = "air";
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  endif;
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R1-w1/2, w1,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  [CSX, params] = CreateHollowRect(CSX, rect1, translate, rotate);
  [CSX, params] = CreateHollowRect(CSX, rect2, translate, rotate);
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular rings and rects made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n"];
  return;
endfunction