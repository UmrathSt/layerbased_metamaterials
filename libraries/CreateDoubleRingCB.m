function [CSX, params] = CreateDoubleRingCB(CSX, object, translate, rotate);
  object = object;
  box_start = [0, 0, object.lz/2];
  box_stop = -box_start;
  % create a 4x4 ring unitcell with equal ring pairs
  % in the I/III and II/IVth quadrant of the unit-cell
  R1 = object.R1;
  w1 = object.w1;
  R2 = object.R2;
  w2 = object.w2;
  R3 = object.R3; % other ring-pair
  w3 = object.w3;
  R4 = object.R4;
  w4 = object.w4;
  shift13 = [object.UClx/4, object.UCly/4, 0];
  shift24 = [-object.UClx/4, object.UCly/4, 0];
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
  % quadrant I
  ocenter = [object.xycenter(1:2), 0] + translate + shift13
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R1-w1/2, w1,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n"];
  % quadrant III
  ocenter = [object.xycenter(1:2), 0] + translate - shift13
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R1-w1/2, w1,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R2-w2/2, w2,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R1) ", " num2str(R2) " ringwidths w1, w2=" num2str(w1) ", " num2str(w2) ", background material " bmaterial "\n"];
  % quadrant II
  ocenter = [object.xycenter(1:2), 0] + translate + shift24
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R3-w3/2, w3,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R4-w4/2, w4,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R3, R4=" num2str(R3) ", " num2str(R4) " ringwidths w3, w4=" num2str(w3) ", " num2str(w4) ", background material " bmaterial "\n"];
  % quadrant IV
  ocenter = [object.xycenter(1:2), 0] + translate - shift24
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R3-w3/2, w3,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  CSX = AddCylindricalShell(CSX, ringmaterial, object.prio+1, 
        ring_start, ring_stop, R4-w4/2, w4,
        'Transform', {'Rotate_Z', rotate, 'Translate', ocenter});
  params = ["# circular rings made of "  ringmaterial " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# radius R1, R2=" num2str(R3) ", " num2str(R4) " ringwidths w3, w4=" num2str(w3) ", " num2str(w4) ", background material " bmaterial "\n"];
  return;
endfunction