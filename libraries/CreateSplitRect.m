function [CSX, params] = CreateSplitRect(CSX, object, translate, rotate);
% Create a NxN rectangular Splitring array with (outer) edgelengths L1
% and L2, width w and gap length of gap copper linewidth of w
  L1 = object.L1;
  w1 = object.w1;
  L2 = object.L2;
  w2 = object.w2;
  Nx = object.Nx; % the number of units in one line
  Ny = object.Ny; % number of elements in one column
  gap = object.gap
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
  % now add the split rectangles and rotate them
  angles = [0, pi/2, pi, 3*pi/2];
  tx = UClx*linspace(-0.5, 0.5, Nx)*(Nx-1)/Nx;
  ty = UCly*linspace(-0.5, 0.5, Ny)*(Ny-1)/Ny;
  ii = 0;
  rot_shift = 0;
  column = 0;
  for TX = tx;
    column = column + 1;
    sgn = (-2*mod(column,2)+1);
    rot_shift = rot_shift + pi/2;
    for TY = ty;
      % horizontal bar
      %  _ gap _
      %  |     | L2
      %  |     | 
      %   -----
      %     L1
      i_angle = mod(ii, 4) + 1;
      ii = ii + 1;
      quadrant = [TX, TY, 0];
      box_start = [-L1/2, -L2/2,   -lz/2];
      box_stop  = [+L1/2, -L2/2+w2, +lz/2];
      CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
           'Transform', {'Rotate_Z', rotate+sgn*angles(i_angle)+rot_shift, 'Translate', translate+quadrant});
      % vertical bars
      box_start = [-L1/2,  -L2/2, -lz/2];
      box_stop  = [-L1/2+w1, L2/2, +lz/2];
      CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
           'Transform', {'Rotate_Z', rotate+sgn*angles(i_angle)+rot_shift, 'Translate', translate+quadrant});
      box_start = [L1/2,  -L2/2, -lz/2];
      box_stop  = [L1/2-w1, L2/2, +lz/2];
      CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
           'Transform', {'Rotate_Z', rotate+sgn*angles(i_angle)+rot_shift, 'Translate', translate+quadrant});
      % gaps
      box_start = [-L1/2, L2/2,   -lz/2];
      box_stop  = [-gap/2, L2/2-w2, +lz/2];
      CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
           'Transform', {'Rotate_Z', rotate+sgn*angles(i_angle)+rot_shift, 'Translate', translate+quadrant});
      box_start = [L1/2, L2/2,   -lz/2];
      box_stop  = [gap/2, L2/2-w2, +lz/2];
      CSX = AddBox(CSX, material, object.prio+1, box_start, box_stop,...
           'Transform', {'Rotate_Z', rotate+sgn*angles(i_angle)+rot_shift, 'Translate', translate+quadrant});
      
    end;
  end;

  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ['# ' num2str(Nx) 'x' num2str(Ny) ' array of Split-Rect-patches made of '  material '. L1, L2, w1, lz, gap = ' num2str(L1) ', ' num2str(L2) ', ' num2str(w1) ', ' num2str(lz) ', ' num2str(gap) ',  at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n' ...
            '# in background material made of ' bmaterial '.\n'];
  return;
end