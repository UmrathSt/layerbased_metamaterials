function [CSX, params] = CreateTreeVias(CSX, object, translate, rotate)

  if !(nargin == 4);
    display('Falsche Parameterzahl für CreatePlus');
  end; 
  L1 = object.L1;
  L2 = object.L2;
  w = object.w;
  lz = object.lz;
  tx = object.tx;
  ty = object.ty;
  R = object.R;
  Lres = object.Lres;
  vias_lz = object.vias_lz;
  UClx = object.UClx;
  UCly = object.UCly;

  start1 = [-L2/2, L1*0.69/2-w/2, -lz/2];
  stop1  = [+L2/2, L1*0.69/2+w/2, +lz/2];
  start2 = [-L2/2, -L1*0.69/2-w/2, -lz/2];
  stop2  = [+L2/2, -L1*0.69/2+w/2, +lz/2];
  start = [-UClx/2, -UCly/2, -lz/2];
  stop = -start;
  CSX = AddBox(CSX, object.bmaterial.name, object.prio, start, stop, 'Transform', {'Translate', translate});
  for trans_x = [tx, -tx];
    for trans_y = [ty, -ty];
      txy = [trans_x, trans_y, 0];
      cstart = txy + [0, 0, -lz/2];
      cstop  = cstart + [0, 0, vias_lz+lz/2];
      CSX = AddCylinder(CSX, object.material.name, object.prio+1, cstart, cstop, R, 'Transform', {'Translate', translate, 'Rotate_Z', rotate});
      CSX = AddBox(CSX, object.material.name, object.prio+1, start1, stop1, 'Transform', {'Translate', txy+translate, 'Rotate_Z', rotate});
      CSX = AddBox(CSX, object.material.name, object.prio+1, start2, stop2, 'Transform', {'Translate', txy+translate, 'Rotate_Z', rotate});
      CSX = AddBox(CSX, object.material.name, object.prio+1, start1, stop1, 'Transform', {'Translate', txy+translate, 'Rotate_Z', rotate+2*pi/4});
      CSX = AddBox(CSX, object.material.name, object.prio+1, start2, stop2, 'Transform', {'Translate', txy+translate, 'Rotate_Z', rotate+2*pi/4});
    end;
  end;
  % resistors

  start = [tx - w/2, -Lres/2-w/2, -lz/2];
  stop  = [tx + w/2, +Lres/2+w/2, +lz/2];
  CSX = AddBox(CSX, object.resistor.name, object.prio+2, start, stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+4*pi/4});
  CSX = AddBox(CSX, object.resistor.name, object.prio+2, start, stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+2*pi/4});
  CSX = AddBox(CSX, object.resistor.name, object.prio+2, start, stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+6*pi/4});
  CSX = AddBox(CSX, object.resistor.name, object.prio+2, start, stop, 'Transform', {'Translate', translate, 'Rotate_Z', rotate+0*pi/4});
  
  
  ocenter = [object.xycenter, 0] + translate;
  params = ['# tree-patch with center vias made of '  object.material.name ' L1, L2, w, lz = ' num2str(object.L1) ', ' num2str(L2) ', ' num2str(object.w) ', ' num2str(object.lz) ' at center position x = ' num2str(ocenter(1)) ' y = ' num2str(ocenter(2)) ' z = ' num2str(ocenter(3)) '\n'];
  return;
endfunction