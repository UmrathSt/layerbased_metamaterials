function [CSX, params] = CreateRingPlus(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  w = object.w;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = "air";
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
  plus.lx = object.pluslx;
  plus.ly = object.plusly;
  plus.lz = object.pluslz;
  plus.wx = object.pluswx;
  plus.wy = object.pluswy;
  plus.center = [object.xycenter(1:2), 0];
  plus.prio = object.prio;
  plus.material = object.material.name;
  [CSX, drop_me] = CreatePlus(CSX, plus, translate, rotate);
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular ring with plus made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1 =" num2str(R1) ", ringwidths w1, w2=" num2str(w1) ", background material " bmaterial "\n" \
            "# plus of lx, ly, lz = " num2str(plus.lx) ", " num2str(plus.ly) ", " num2str(plus.lz) ", wx=wy = " num2str(plus.wx) "\n"];
  return;
endfunction