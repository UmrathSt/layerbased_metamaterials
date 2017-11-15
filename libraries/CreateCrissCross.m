function [CSX, params] = CreateCrissCross(CSX, object, translate, rotate)
% Create a criss-cross-structure defined in "Optics Express 20, 4675-4680
% by L. K. Sun, H. F. Cheng, Y. J. Zhou, J. Wang
  w1 = object.w1;
  w2 = object.w2;
  l1 = object.l1;
  l2 = object.l2;
  lz = object.lz;
  UClx = object.UClx;
  UCly = object.UCly;
  
  %% top cross which can be rotated to the crosses in +-x and +-y
  start1 = [-l1/2, UCly/2, -lz/2];
  stop1  = [+l1/2, UCly/2-w1, lz/2];
  start2 = [-w2/2, UCly/2, -lz/2];
  stop2  = [+w2/2, UCly/2-l2-w1, lz/2];
  z_angles = [0, pi/2, pi, 3*pi/2];
  for alpha = z_angles;
      CSX = AddBox(CSX, object.material.name, 2, start1, stop1, 'Transform', {'Rotate_Z', alpha+rotate, 'Translate', translate});
      CSX = AddBox(CSX, object.material.name, 2, start2, stop2, 'Transform', {'Rotate_Z', alpha+rotate, 'Translate', translate});
  end;
  
 
  
  ocenter = [object.xycenter, 0] + translate;
  params = ['# criss-cross patch made of ',  object.material.name,  '\n'];
  params = horzcat(params, get_geometry_info_string);
  return;
end