function [CSX, params, mesh_lines] = CreatePolygon(CSX, object, translate, rotate);
    % create a polygon which takes care of the mesh lines
    % itself.
  object = object;
  pts = object.pts; % x and y coordinates of points
  cutout = 'False';
  try;
  cpts = object.cpts; 
      for i = 1:size(cpts)(1);
      cp(1, i) = cpts(i, 1); cp(2, i) = cpts(i, 2);
  end;
  cp(1, i+1) = cpts(1, 1); cp(2, i+1) = cpts(1,2);
  cutout = 'True';
  catch lasterror;
  end;  

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
  params = [params, "# polygonal patch made of "  object.material.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  params = [params, '# points (x, y): ' mat2str(pts) '\n'];
  if strcmp(cutout, 'True');
    [CSX, params] = defineMaterial(CSX, object.cmaterial, '');
    CSX = AddLinPoly(CSX, object.cmaterial.name, object.prio+1, 2, object.lz/2, cp , -object.lz, 'CoordSystem',0,...
    'Transform', {'Rotate_Z', rotate, 'Translate', translate});
    params = [params, "# cutout of polygonal patch made of "  object.cmaterial.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
    params = [params, '# points (x, y): ' mat2str(cpts) '\n'];
  end;
  
endfunction