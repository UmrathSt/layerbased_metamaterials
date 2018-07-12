function [CSX, mesh, param_str, UC] = stack_layers(layer_list);
 %% takes a list of structures describing layers. Example:
 %% layer_list = [(@CreateRect, rectangle_object),
 %%               (@CreateCircle, circle_object)]
 %% first list entry is supposed to describe unitcell dimensions
 %% development
  CSX = InitCSX();
  zvals = [0];
  xvals = [];
  yvals = [];
  zc = layer_list{2,2}.lz/2;
  UC = layer_list{1,2};
  % use only a quarter of the unit-cell for the simulation
  % if the symmetry is high


  UC_handler = layer_list{1,1};
  param_str = ['# stacked metamaterial geometry \n# f [Hz], L [' num2str(UC.unit) ' m]\n'];

  [CSX, params] = UC_handler(CSX, UC, [0, 0, 0], 0);
  param_str = horzcat(param_str, params);
  for i = 2:size(layer_list, 1); % layer 1 is the Unit-Cell
      object = layer_list{i, 2};
      object_before = layer_list{i-1,2};
      object_handler = layer_list{i, 1};
      
      zc = zc-object.lz/2-object_before.lz/2*(i>2);
      zvals = [zvals,zc-object.lz/2];
      translate = [object.xycenter(1:2), zc];%
      fprintf(horzcat('Adding object ', object.name, ' at z-coordinate Z0 = ', num2str(object.lz/2), '\n')); 
      rotate = object.rotate;
      param_str = horzcat(param_str, ['# layer number ' num2str(i-1) ':\n']);
      [CSX, params, mesh_lines] = object_handler(CSX, object, translate, rotate);
      % mesh_lines are the object-centered desired mesh lines
      param_str = horzcat(param_str, params);
      xvals = [xvals, mesh_lines.x];
      yvals = [yvals, mesh_lines.y];
      zvals = [zvals,  zvals(end)+mesh_lines.z];
  end;
      
  lastz = zvals(end);
  UC.lastz = lastz;

  mesh.x = SmoothMeshLines([-UC.lx/2, xvals, UC.lx/2], UC.dx, 1.3);
  mesh.y = SmoothMeshLines([-UC.ly/2, yvals, UC.ly/2], UC.dy, 1.3);
  if not(UC.grounded);
    mesh.z = SmoothMeshLines([-UC.lz/2, zvals, UC.lz/2], UC.dz, 1.4);
  else;
    mesh.z = SmoothMeshLines([-7*UC.lz/8, zvals, 1*UC.lz/8], UC.dz, 1.4);
  end;
  CSX = DefineRectGrid(CSX, UC.unit, mesh);
  mesh = AddPML(mesh, [0 0 0 0 8 8]);
      end
