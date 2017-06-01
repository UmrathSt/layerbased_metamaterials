function [CSX, params] = CreateResistiveDoubleRing(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
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
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R1-w1/2, w1,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n" \
            "# outer ring coupled via four R=" num2str(object.Resistance) " Ohm resistors to the neighbouring unitcells]."];
  Rlarger = max(R1, R2);
  r_start = [-object.ResWidth/2, Rlarger-object.ResWidth/2, -object.lz/2];
  r_stop  = [+object.ResWidth/2, object.UCly/2, +object.lz/2];
  for angle = pi/2 .*(0:3);
    direction = abs(round(cos(angle)));
    rname = ["Resistance_" num2str(round(angle*180/pi))];
    start = [r_start(1)*round(cos(angle)) + r_start(2)*round(sin(angle)), -r_start(1)*round(sin(angle))+r_start(2)*round(cos(angle)), r_start(3)];
    stop  = [r_stop(1) *round(cos(angle)) + r_stop(2) *round(sin(angle)), -r_stop(1) *round(sin(angle))+r_stop(2) *round(cos(angle)), r_stop(3)];
    CSX = AddLumpedElement(CSX, rname, direction,'R', object.Resistance);
    CSX = AddBox(CSX, rname, object.prio, start, stop, 'Transform', {'Rotate_Z', rotate, 'Translate', translate});  
  endfor;
  return;
endfunction