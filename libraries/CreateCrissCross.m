function [CSX, params] = CreateCrissCross(CSX, object, translate, rotate)
% Create a criss-cross-structure defined in "Optics Express 20, 4675-4680
% by L. K. Sun, H. F. Cheng, Y. J. Zhou, J. Wang
  w1 = object.w1;
  w2 = object.w2;
  l1 = object.l1;
  l2 = object.l2;
  lz = object.lz;
  Lsmall = object.Lsmall;
  Llarge = object.Llarge;
  UClx = object.UClx;
  UCly = object.UCly;
  xshift = (object.a - 2*l2)/2;
  yshift = xshift;
  
  %% top cross which can be rotated to the crosses in +-x and +-y
  start1 = [-l1/2, UCly/2, -lz/2];
  stop1  = [+l1/2, UCly/2-w1, lz/2];
  start2 = [-w2/2, UCly/2, -lz/2];
  stop2  = [+w2/2, UCly/2-l2-w1, lz/2];
  z_angles = [0, pi/2, pi, 3*pi/2];
  for alpha = z_angles;
      CSX = AddBox(CSX, object.material.name, object.prio+1, start1, stop1, 'Transform', {'Rotate_Z', alpha+rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.material.name, object.prio+1, start2, stop2, 'Transform', {'Rotate_Z', alpha+rotate, 'Translate', translate});
  end;
  
  b1_start = [-Lsmall/2, -Lsmall/2, -lz/2];
  b1_stop  = -b1_start;
  b2_start = [-Llarge/2, -Llarge/2, -lz/2];
  b2_stop  = -b2_start;
  for xs = [-xshift, xshift];
      for ys = [-xshift, xshift];
          transl = [xs, ys, 0]+translate;
          CSX = AddBox(CSX, object.material.name, object.prio+1, b1_start, b1_stop, 'Transform', {'Rotate_Z', rotate, 'Translate', transl});
          CSX = AddBox(CSX, object.material.name, object.prio+1, b2_start, b2_stop, 'Transform', {'Rotate_Z', rotate, 'Translate', transl});
      end;
  end;
  
  start = [-UClx/2, -UCly/2, -lz/2];
  stop  = -start;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, start, stop, 'Transform', {'Translate', translate});
  
  ocenter = [object.xycenter, 0] + translate;
  params = ['# Parameters for object ', object.name];
  params = horzcat(params, ['\n# Crosses:', 'L1, L2 = ', num2str(object.Lsmall), ', ', object.Llarge ', ']);
  params = horzcat(params, ['l1, l2, w1, w2 = ', num2str(l1), num2str(l2), num2str(object.w1), num2str(object.w2), '\n']);
  params = horzcat(params, ['# background material is', object.bmaterial.name, '\n']);
  return;
end