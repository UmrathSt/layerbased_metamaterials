function [CSX, params] = CreateDoubleSplitRing(CSX, object, translate, rotate);
  % rings splitted at x = 0
  % so that the gap is not at the nodes
  % of the resonances
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  split_angle1 = object.split_angle1;
  split_angle2 = object.split_angle2;
  ROhm = object.ROhm;
  R2 = object.R2;
  w2 = object.w2;
  lz = object.lz;
  ring_start = [0, 0, -object.lz/2];
  ring_stop = [0, 0, object.lz/2];
  ringmaterial = object.material.name;
  bmaterial = object.bmaterial.name;
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = -bstart;
  CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  if object.complemential;
    try;
    CSX = AddMaterial(CSX, "air");
    CSX = SetMaterialProperty(CSX, "air", "Epsilon", 1);
    catch lasterror;
    end_try_catch;
    ringmaterial = "air";
    bmaterial = object.material.name;
    bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
    bstop  = -bstart;
    CSX = AddBox(CSX, bmaterial, object.prio, bstart, bstop,
            'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  endif;
  CSX = AddLumpedElement(CSX, "resistor", "x", 'R', ROhm);
  for alpha = (0:3) .* pi/2;
    CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
          ring_start, ring_stop, R1-w1/2, w1,
          'Transform', {'Rotate_Z', alpha, 'Translate', translate});
    % y, z coords of gap cross section
    enlarge = 1.025;
    pts(1,1) = R1*enlarge; pts(2,1) = -lz/2;
    pts(1,2) = R1*enlarge; pts(2,2) = +lz/2;
    pts(1,3) = R1/enlarge-w1; pts(2,3) = +lz/2;
    pts(1,4) = R1/enlarge-w1; pts(2,4) = -lz/2;
    CSX = AddRotPoly(CSX, bmaterial, object.prio+2, 0, pts, 2, [-split_angle1/2, split_angle1/2],
          'Transform', {'Translate', translate, 'Rotate_Z', alpha});
    
    rlength = 1.3*split_angle1*R1;
    start = [-rlength/2, R1-w1/3, -lz/2];
    stop  = [rlength/2, R1-2*w1/3, lz/2];
    CSX = AddBox(CSX, "resistor", object.prio+2, start, stop,
          'Transform', {'Translate', translate, 'Rotate_Z', alpha});
  endfor;
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate+alpha, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n" \
            "# larger ring split of alpha = " num2str(split_angle1) " by resistor of " num2str(ROhm) " Ohm \n"];
  return;
endfunction