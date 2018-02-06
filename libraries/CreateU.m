function [CSX, params] = CreateU(CSX, object, translate, rotate);
% Create a rectangular ring with (outer) edgelength L
% and copper linewidth of w
  L1 = object.L1;
  w1 = object.w1;
  L2 = object.L2;
  w2 = object.w2;
  UClx = object.UClx;
  UCly = object.UCly;
  bmaterial = object.bmaterial.name;
  material = object.material.name;
  lz = object.lz;
  if object.complemential;
    tmp = bmaterial;
    bmaterial = material;
    material = tmp;
  end;
  % Add the background material
  box_start = [-UClx/2, -UCly/2, -lz/2];
  box_stop  = -box_start;
  CSX = AddBox(CSX, bmaterial, object.prio, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  % now add four rectangles by rotating them
  angles = [0, pi/2, pi, 3*pi/2];
  tx = [UClx/4, -UClx/4, -UClx/4, +UClx/4];
  ty = [UCly/4, +UCly/4, -UCly/4, -UCly/4];
  for i_angle = 1:numel(angles);
    quadrant = [tx(i_angle), ty(i_angle), 0];
    % horizontal bar
    box_start = [-L1/2, -L2/2,   -lz/2];
    box_stop  = [+L1/2, -L2/2+w2, +lz/2];
    CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate+angles(i_angle), 'Translate', translate+quadrant});
    % vertical bars
    box_start = [-L1/2,  -L2/2, -lz/2];
    box_stop  = [-L1/2+w1, L2/2, +lz/2];
    CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate+angles(i_angle), 'Translate', translate+quadrant});
    box_start = [L1/2,  -L2/2, -lz/2];
    box_stop  = [L1/2-w1, L2/2, +lz/2];
    CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
         'Transform', {'Rotate_Z', rotate+angles(i_angle), 'Translate', translate+quadrant});
  end;

  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# U-patches made of '  material '. L1, L2, w1, lz = ' num2str(L1) ',  at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n' ...
            '# in background material made of ' bmaterial '.\n'];
  return;
end