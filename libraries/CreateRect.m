function [CSX, params, mesh_lines] = CreateRect(CSX, object, translate, rotate);
    % create a homogenious rectangle which takes care of the mesh lines
    % itself.
  object = object;
  diag = [object.lx/2, object.ly/2, object.lz/2];
  box_start = -diag;
  box_stop = +diag;
  % this object needs no special meshlines
  mesh_lines.x = [];
  mesh_lines.y = [];
  mesh_lines.z = [];
  CSX = AddBox(CSX, object.material.name, object.prio, box_start, box_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# rect patch made of "  object.material.name " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction