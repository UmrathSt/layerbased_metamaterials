function [CSX, params] = CreateEdgeCircSlottedRect(CSX, object, translate, rotate);
  object = object;
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  Rcenter = object.Rcenter;
  Redge = object.Redge;

  CSX = AddBox(CSX, object.material.name, object.prio, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ring_start = [0, 0, box_start(3)];
  ring_stop = [0, 0, box_stop(3)];
  CSX = AddCylinder(CSX, object.circlematerial.name, object.prio+1, 
        ring_start, ring_stop, Rcenter,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  for i = [-1, 1];
    for j = [-1, 1];
        CSX = AddCylinder(CSX, object.circlematerial.name, object.prio+1, 
        ring_start, ring_stop, Redge,
        'Transform', {'Rotate_Z', rotate, 'Translate', translate+[i*(object.lx/2), j*(object.ly/2), 0]});
    end;
  end;  
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# circular slotted rect patch made of "  object.material.name " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# circle material " object.circlematerial.name " radius R=" num2str(Rcenter) "\n" \ 
            "# edge circle material " object.circlematerial.name " radius R=" num2str(Redge) "\n"];
  return;
endfunction