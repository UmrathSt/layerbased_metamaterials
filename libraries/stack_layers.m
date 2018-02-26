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
  UC = layer_list{1,2};
  UC_handler = layer_list{1,1};
  param_str = ['# stacked metamaterial geometry \n# f [Hz], L [' num2str(UC.unit) ' m]\n'];
  [CSX, params] = UC_handler(CSX, UC, [0, 0, 0], 0);
  param_str = horzcat(param_str, params);
  [CSX, params] = defineMaterials(CSX, material_list, param_str);
  param_str = horzcat(param_str, params);
  for i = 2:size(layer_list, 1); % layer 1 is the Unit-Cell
        object = layer_list{i, 2};
        object_handler = layer_list{i, 1};
        refiner = 0;
        %display(['working on ' object.name]);
        try;
          refiner = object.zrefinement;
        end;
      if refiner;
        zvals = horzcat(zvals, linspace(zvals(end), zvals(end)-object.lz, refiner));
      else;
        zvals = horzcat(zvals, [zvals(end)-object.lz]);
      % old:
      % zvals = horzcat(zvals, [zvals(end)-object.lz/2, zvals(end)-object.lz]);

  end;
  do_xy_meshing = 1;
  try;
    do_xy_meshing = object.do_xy_meshing;
  catch lasterror;
  end;
  if do_xy_meshing;

      try;
        R = object.R1;
        w = object.w1;
        xvals = horzcat(xvals, [-(UC.lx/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.lx/2+R)/2]);
        yvals = horzcat(yvals, [-(UC.ly/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.ly/2+R)/2]);    
      catch lasterror;
      end;
      try;
        R = object.R2;
        w = object.w2;
        xvals = horzcat(xvals, [-(UC.lx/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.lx/2+R)/2]);
        yvals = horzcat(yvals, [-(UC.ly/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.ly/2+R)/2]);    
      catch lasterror;
    end;
    try;
        R = object.Lhex1;
        w = object.whex1;
        xvals = horzcat(xvals, [-R, -R+w, -w/2, w/2, R-w, R]);
        yvals = horzcat(yvals, [-R, -R+w, -w/2, w/2, R-w, R]);    
      catch lasterror;
    end;
    try;
        R = object.Lhex2;
        w = object.whex2;
        xvals = horzcat(xvals, [-R, -R+w, -w/2, w/2, R-w, R]);
        yvals = horzcat(yvals, [-R, -R+w, -w/2, w/2, R-w, R]);    
      catch lasterror;
    end;
        try;
        R = object.R3;
        w = object.w3;
        xvals = horzcat(xvals, [-(UC.lx/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.lx/2+R)/2]);
        yvals = horzcat(yvals, [-(UC.ly/2+R)/2, -R, -R+w, -w/2, w/2, R-w, R, (UC.ly/2+R)/2]);    
      catch lasterror;
      end;
      try;
          s = [1];
          try;
          s = object.scales;
          catch lasterror;
          end;
          TX = [-UClx/4, -UClx/4, UClx/4, UClx/4];
          TY = [-UCly/4, UCly/4, -UCly/4, UCly/4];
          for i_sc = 1:numel(s);
              sc = s(i_sc);
              tx = TX(i_sc);
              ty = TY(i_sc);
              
              L1 = object.L1*sc;
              L2 = object.L2*sc;
              w1 = object.w1*sc;
              xvals = horzcat(xvals, [-L1/2, -L1/2+w1, -L2/2, L2/2, L1/2-w1, L1/2]+tx);
              yvals = horzcat(xvals, [-L1/2, -L1/2+w1, -L2/2, L2/2, L1/2-w1, L1/2]+ty);
              try;
                w2 = object.w2*sc;
                xvals = horzcat(xvals, [-L2/2+w2, L2/2-w2]+tx);
                yvals = horzcat(xvals, [-L2/2+w2, L2/2-w2]+ty);
              catch lasterror;
              end;
          end;
      catch lasterror;
      end;
      try;
        L3 = object.L3;
        xvals = horzcat(xvals, [-L3/2, L3/2]);
        yvals = horzcat(xvals, [-L3/2, L3/2]);
      catch lasterror;
      end;
      try;
        Lres1 = object.Lres1;
        Lres2 = object.Lres2;
        xvals = horzcat(xvals, [-Lres1/2, -Lres2/2, Lres2/2, Lres1/2]);
        yvals = horzcat(yvals, [-Lres1/2, -Lres2/2, Lres2/2, Lres1/2]);
        catch lasterror;
      end;
      try;
        R = object.R;
        w = object.w;
        xvals = horzcat(xvals, [-(UC.lx/2+R)/2, -R, -R+w, R-w, R, (UC.lx/2+R)/2]);
        yvals = horzcat(yvals, [-(UC.ly/2+R)/2, -R, -R+w, R-w, R, (UC.ly/2+R)/2]);    
      catch lasterror;
      end;
      %printf('creating object: %s \n', object.name);
      add_trans = [0, 0, 0];
      try;
        add_trans = object.translate;
      catch lasterror;
      end;
      try;
          w1 = object.w1; % y
          w2 = object.w2; % x
          a = object.a;
          b = object.b;
          xvals = horzcat(xvals, [-(UC.lx/2-w1),-(UC.lx/2-(a-b)), -w2/2, w2/2, (UC.lx/2-(a-b)), (UC.lx/2-w1)/2]);
          yvals = horzcat(yvals, [-(UC.ly/2-w1),-(UC.ly/2-(a-b)), -w2/2, w2/2, (UC.ly/2-(a-b)), (UC.ly/2-w1)/2]);
          
      catch lasterror;
    end;
    end;


      translate = [object.xycenter(1:2), zvals(end)+object.lz/2]+ add_trans;
      rotate = object.rotate;
      param_str = horzcat(param_str, ['# layer number ' num2str(i-1) ':\n']);
      [CSX, params] = object_handler(CSX, object, translate, rotate);
      param_str = horzcat(param_str, params);
      end;
      
  
  lastz = zvals(end);
  
  mesh.x = SmoothMeshLines([-UC.lx/2, xvals, UC.lx/2], UC.dx, 1.3);
  mesh.y = SmoothMeshLines([-UC.ly/2, yvals, UC.ly/2], UC.dy, 1.3);
  if not(UC.grounded);
    mesh.z = SmoothMeshLines([-UC.lz/2, zvals, UC.lz/2], UC.dz, 1.4);
  else;
    mesh.z = SmoothMeshLines([-7*UC.lz/8, zvals, 1*UC.lz/8], UC.dz, 1.3);
  end;
  CSX = DefineRectGrid(CSX, UC.unit, mesh);
  mesh = AddPML(mesh, [0 0 0 0 8 8]);
      end
