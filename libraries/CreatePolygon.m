function [CSX, params, mesh_lines] = CreatePolygon(CSX, object, translate, rotate);
    % create a polygon which takes care of the mesh lines
    % itself.
  object = object;
  pts = object.pts; % x and y coordinates of points
  cutout = 'False';
  try;
  cpts = object.cpts; 
  UCDim = object.lx;
  maxvals.x = [];
  maxvals.y = [];
  if iscell(cpts);
    display("Cutting out multiple polygons");
        for j = 1:length(cpts);    % loop over polygons to cutout
            maxvals.x = unique([maxvals.x, unique(cpts{j}(1,:))]);
            maxvals.y = unique([maxvals.y, unique(cpts{j}(2,:))]);
          for i = 1:size(cpts{j})(2); % loop over points of polygon
            cp{j}(1,i) = cpts{j}(1,i); 
            cp{j}(2,i) = cpts{j}(2,i);
          end;
          cp{j}(1,i+1) = cpts{j}(1,1); 
          cp{j}(2,i+1) = cpts{j}(2,1);
        end;
    else;
      error("Polygons are supposed to be defined by cell arrays");
  end;
  cutout = 'True';
  catch lasterror;
  end;  
if iscell(pts);
        display("Adding multiple polygons");
        for j = 1:length(pts);    % loop over polygons to cutout
          maxvals.x = unique([maxvals.x, unique(pts{j}(1,:))]);
          maxvals.y = unique([maxvals.y, unique(pts{j}(2,:))]);
          for i = 1:size(pts{j})(2); % loop over points of polygon
            p{j}(1,i) = pts{j}(1,i); 
            p{j}(2,i) = pts{j}(2,i);
          end;
          p{j}(1,i+1) = pts{j}(1,1); 
          p{j}(2,i+1) = pts{j}(2,1);

        end;
else;
  error("Polygons are supposed to be defined by cell-arrays.");

  % this object needs no special meshlines
end;
  xMinMax = [min(maxvals.x), max(maxvals.x)];
  yMinMax = [min(maxvals.y), max(maxvals.y)];
  mesh_lines.x = [-(UCDim/2+xMinMax(1))/2, maxvals.x, (UCDim/2+xMinMax(2))/2];
  mesh_lines.y = [-(UCDim/2+yMinMax(1))/2, maxvals.y, (UCDim/2+yMinMax(2))/2];
  mesh_lines.z = [0];

  [CSX, params] = defineMaterial(CSX, object.material, '');
  if iscell(p);
      for j = 1:length(p); 
          CSX = AddLinPoly(CSX, object.material.name, object.prio, 2, object.lz/2, p{j} , -object.lz, 'CoordSystem',0,...
        'Transform', {'Rotate_Z', rotate, 'Translate', translate});
          ocenter = [object.xycenter(1:2), 0] + translate;
          params = [params, "# polygonal patch made of "  object.material.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
          params = [params, '# points (x, y): ' mat2str(p{j}') '\n'];
      end;
      else;
      
      CSX = AddLinPoly(CSX, object.material.name, object.prio, 2, object.lz/2, p , -object.lz, 'CoordSystem',0,...
    'Transform', {'Rotate_Z', rotate, 'Translate', translate});
      ocenter = [object.xycenter(1:2), 0] + translate;
      params = [params, "# polygonal patch made of "  object.material.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
      params = [params, '# points (x, y): ' mat2str(pts') '\n'];
  end;
  if strcmp(cutout, 'True');
    [CSX, params] = defineMaterial(CSX, object.cmaterial, '');
    if iscell(cp);
        for j = 1:length(cp);   
            CSX = AddLinPoly(CSX, object.cmaterial.name, object.prio+1, 2, object.lz/2, cp{j} , -object.lz, 'CoordSystem',0,...
    'Transform', {'Rotate_Z', rotate, 'Translate', translate});
            params = [params, "# cutout of polygonal patch made of "  object.cmaterial.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
            params = [params, '# points (x, y): ' mat2str(cpts{j}') '\n'];
        end;
    else;
        CSX = AddLinPoly(CSX, object.cmaterial.name, object.prio+1, 2, object.lz/2, cp , -object.lz, 'CoordSystem',0,...
    'Transform', {'Rotate_Z', rotate, 'Translate', translate});
        params = [params, "# cutout of polygonal patch made of "  object.cmaterial.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
        params = [params, '# points (x, y): ' mat2str(cpts') '\n'];
    end;
    
  end;
  
endfunction