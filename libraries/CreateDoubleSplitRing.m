function [CSX, params] = CreateDoubleSplitRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
  g1 = object.g1;
  g2 = object.g2;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = "air";
  CSX = AddMaterial(CSX, "air");
  CSX = SetMaterialProperty(CSX, "air", "Epsilon", 1);
  if object.complemential;
    ringmaterial = "air";
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  endif;
  # create 4 splits for the two rings
  for angle = [pi/2];
    g1start = [-g1/2, R1, object.lz/2];
    g1stop  = [+g1/2, R1-w1, -object.lz/2];
    g2start = [-g2/2, R2, object.lz/2];
    g2stop  = [+g2/2, R2-w2, -object.lz/2];
    CSX = AddBox(CSX, bmaterial, object.prio+2, g1start, g1stop,
    'Transform', {'Rotate_Z', rotate+angle, 'Translate', translate});
    CSX = AddBox(CSX, bmaterial, object.prio+2, g2start, g2stop,
    'Transform', {'Rotate_Z', rotate+angle+pi, 'Translate', translate});
  endfor;
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R1-w1/2, w1,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n"];
  return;
endfunction