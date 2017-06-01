function [CSX, params] = CreateCircSlottedRect(CSX, object, translate, rotate);
  object = object;
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  Ra = object.ringradius;
  w = object.ringwidth;
  CSX = AddBox(CSX, object.material.name, object.prio, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ring_start = [0, 0, box_start(3)];
  ring_stop = [0, 0, box_stop(3)];
  CSX = AddCylindricalShell(CSX, object.ringmaterial.name, object.prio+1, 
        ring_start, ring_stop, Ra-w/2, w,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular ring slotted rect patch made of "  object.material.name " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# ringmaterial " object.ringmaterial.name " outer ring radius Ra=" num2str(Ra) " ringwidth w=" num2str(w) "\n"];
  return;
endfunction