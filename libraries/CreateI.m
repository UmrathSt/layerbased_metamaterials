function [CSX, params, lastz] = CreateI(CSX, object, translate, rotate)
  if !(nargin == 4);
    display("Falsche Parameterzahl für CreateI");
  end; 
  lastz.c = translate(3);
  lastz.lz = object.lz;
  upperH_start = [object.lx/2, object.ly/2, -object.lz/2];
  upperH_stop = [-object.lx/2, object.ly/2+object.wy, object.lz/2];
  lowerH_start =  [object.lx/2, -object.ly/2, -object.lz/2];
  lowerH_stop = [-object.lx/2, -object.ly/2-object.wy, object.lz/2];
  centerH_start = [-object.wx/2, -object.ly/2, -object.lz/2];
  centerH_stop =  [object.wx/2, object.ly/2, object.lz/2];
  CSX = AddBox(CSX, object.material, object.prio+1, lowerH_start, lowerH_stop, 
      'Transform',{'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, object.material, object.prio+1, upperH_start, upperH_stop, 
      'Transform',{'Rotate_Z', rotate, 'Translate', translate});
  CSX = AddBox(CSX, object.material, object.prio+1, centerH_start, centerH_stop, 
      'Transform',{'Rotate_Z', rotate, 'Translate', translate});
  ocenter = object.center + translate;
  params = ["# H-patch made of "  object.material " lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
  return;
endfunction