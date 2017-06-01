function [CSX, params] = CreateHollowRect(CSX, object, translate, rotate)
  yarm_start = [-object.lx/2, -object.ly/2, -object.lz/2];
  yarm_stop = [-object.lx/2+object.wx, object.ly/2, object.lz/2];
  xarm_start = [-object.lx/2, -object.ly/2, -object.lz/2];
  xarm_stop = [+object.lx/2, -object.ly/2+object.wy, object.lz/2];
  xshift = [object.lx-object.wx, 0, 0];
  yshift = [0, object.ly-object.wy, 0];
  CSX = AddBox(CSX, object.material.name, object.prio, yarm_start, yarm_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, object.material.name, object.prio, yarm_start+xshift, yarm_stop+xshift,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});       
  CSX = AddBox(CSX, object.material.name, object.prio, xarm_start, xarm_stop,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, object.material.name, object.prio, xarm_start+yshift, xarm_stop+yshift,
         'Transform', {'Rotate_Z', rotate, 'Translate', translate});        
  ocenter = translate;
  params = ["# Hollow rect patch made of "  object.material.name " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x,y,z = " num2str(ocenter(1)) ", " num2str(ocenter(2)) ", " num2str(ocenter(3)) "  wx, wy = " num2str(object.wx) ", " num2str(object.wy) "\n"];
endfunction