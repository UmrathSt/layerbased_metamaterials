function [z_xy] = get_xy_center_z(layer_list);
% modified get_xy_center_z for working with objects which extend
% from one layer to another
  z_xy = [];
  for i = 2:size(layer_list)(1);
    for j = 1: size(layer_list{i});
      if size(z_xy) == 0;
        z_xy = horzcat(z_xy, -layer_list{i}{j, 2}.lz/2);
      else;
        z_xy = horzcat(z_xy, z_xy(end)-layer_list{i-1}{j, 2}.lz/2-layer_list{i}{j, 2}.lz/2);
      endif;
    endfor;
  endfor;

endfunction;