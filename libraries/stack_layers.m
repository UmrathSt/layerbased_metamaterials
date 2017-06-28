function [CSX, mesh, param_str] = stack_layers(layer_list, material_list);
 %% takes a list of structures describing layers. Example:
 %% layer_list = [(@CreateRect, rectangle_object),
 %%               (@CreateCircle, circle_object)]
 %% first list entry is supposed to describe unitcell dimensions
 %% development
  CSX = InitCSX();
  z = 0;
  zvals = [z];
  xvals = [];
  yvals = [];
  layer_list = layer_list;
  UC = layer_list{1}{1, 2};
  UC_handler = layer_list{1}{1, 1};
  param_str = ["# stacked metamaterial geometry \n# f [Hz], L [" num2str(UC.unit) " m]\n"];
  [CSX, params] = UC_handler(CSX, UC, [0, 0, 0], 0);
  param_str = horzcat(param_str, params);
  [CSX, params] = defineMaterials(CSX, material_list, param_str);
  param_str = horzcat(param_str, params);
  for i = 2:(size(layer_list)(1)); % layer 1 is the Unit-Cell
    for j = 1:(size(layer_list{i}(1)));
      object = layer_list{i}{j, 2};
      object_handler = layer_list{i}{j, 1};
      refiner = 0;
      try;
        refiner = object.lz/object.zrefinement;
      end_try_catch;
      if refiner;
        zvals = horzcat(zvals, linspace(zvals(end)-UC.dz/(1+refiner), zvals(end)-object.lz, object.lz/UC.dz*(1+refiner)));
      else;
        zvals = horzcat(zvals, [zvals(end)-object.lz/2, zvals(end)-object.lz]);
      endif;
      try;
        R = object.R1;
        w = object.w1;
        xvals = horzcat(xvals, [-R, -R+w, R-w, R]);
        yvals = horzcat(yvals, [-R, -R+w, R-w, R]);    
      catch lasterror;
      end_try_catch;
      try;
        R = object.R2;
        w = object.w2;
        xvals = horzcat(xvals, [-R, -R+w, R-w, R]);
        yvals = horzcat(yvals, [-R, -R+w, R-w, R]);     
      catch lasterror;
      end_try_catch;
      try;
        R = object.R;
        w = object.w;
        xvals = horzcat(xvals, [-R, -R+w, R-w, R]);
        yvals = horzcat(yvals, [-R, -R+w, R-w, R]);     
      catch lasterror;
      end_try_catch;
      printf("creating object: %s \n", object.name);
      add_trans = [0, 0, 0];
      try;
        add_trans = object.translate;
      catch lasterror;
      end_try_catch;
      translate = [object.xycenter(1:2), zvals(end-j+1)+object.lz/2]+ add_trans;
      rotate = object.rotate;
      param_str = horzcat(param_str, ["# layer number " num2str(i-1) ":\n"]);
      [CSX, params] = object_handler(CSX, object, translate, rotate);
      param_str = horzcat(param_str, params);
    endfor;
  endfor;
  
  lastz = zvals(end);
  
  mesh.x = SmoothMeshLines([-UC.lx/2, xvals, UC.lx/2], UC.dx, 1.1);
  mesh.y = SmoothMeshLines([-UC.ly/2, yvals, UC.ly/2], UC.dy, 1.1);
  if not(UC.grounded);
    mesh.z = SmoothMeshLines2([-UC.lz/2, zvals, UC.lz/2], UC.dz);
  else;
    mesh.z = SmoothMeshLines2([-7*UC.lz/8, zvals, 1*UC.lz/8], UC.dz);
  endif;
  CSX = DefineRectGrid(CSX, UC.unit, mesh);
  mesh = AddPML(mesh, [0 0 0 0 8 8]);
endfunction;