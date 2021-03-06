function [CSX, params] = CreateCoil(CSX, object, translate, rotate);
  N = object.N; # number of windings
  L = object.L;
  w = object.w;
  g = object.g;
  alpha = object.alpha; 
  bmaterial = object.bmaterial; 
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = [+object.UClx/2, +object.UCly/2, +object.lz/2];
  if object.complemential;
    material = object.bmaterial;
    bmaterial = object.material;
  endif;
  CSX = AddBox(CSX, bmaterial.name, object.prio, bstart, bstop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  for i = 1:N;
    [CSX, params] = CreateWinding(CSX, object, translate, alpha);
    object.L -= g*2;
  endfor;
  material = object.material.name;
  bmaterial = object.bmaterial.name;
  ocenter = [object.xycenter(1:2), 0] + translate;

  params = ["# rectangular coil, of material " material " in background material " bmaterial ". Parameters L, g, w, N = "  num2str(L) ", " num2str(g) ", " num2str(w) ", " num2str(N) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" ];
  return;
endfunction