function [CSX, params, mesh_lines] = CreatePolygon(CSX, object, translate, rotate);
    % create a polygon which takes care of the mesh lines
    % itself.
  object = object;
  pts = object.pts; % x and y coordinates of points
  for i = 1:size(pts)(1);
      p(1, i) = pts(i, 1); p(2, i) = pts(i, 2);
  end;
  p(1, i+1) = pts(1, 1); p(2, i+1) = pts(1,2);

  % this object needs no special meshlines
  mesh_lines.x = [];
  mesh_lines.y = [];
  mesh_lines.z = [0];
  [CSX, params] = defineMaterial(CSX, object.material, '');
  CSX = AddLinPoly(CSX, object.material.name, object.prio, 2, object.lz/2, p , -object.lz, 'CoordSystem',0,...
'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = [params, "# rect patch made of "  object.material.name " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction