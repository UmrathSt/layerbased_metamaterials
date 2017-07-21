function [CSX, params] = CreateWinding(CSX, object, translate, rotate);
  L = object.L;
  w = object.w;
  g = object.g;
  # orientation:
  #  | _ _ _ _
  #  |       |
  #  |       |
  #  |_ _ _ _|
  material = object.material;
  bmaterial = object.bmaterial;
  priority = object.prio;
  bstart = [-object.UClx/2, -object.UCly/2, -object.lz/2];
  bstop  = [+object.UClx/2, +object.UCly/2, +object.lz/2];
  if object.complemential;
    material = object.bmaterial;
    bmaterial = object.material;
  endif;
  CSX = AddBox(CSX, bmaterial.name, priority, bstart, bstop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  
  start = [-object.L/2, -object.L/2, -object.lz/2];
  stop  = [-object.L/2+w, object.L/2, object.lz/2];
  CSX = AddBox(CSX, material.name, priority+1, start, stop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  start = [-object.L/2, -object.L/2, -object.lz/2];
  stop  = [object.L/2, -object.L/2+w, object.lz/2];  
  CSX = AddBox(CSX, material.name, priority+1, start, stop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  
  start = [object.L/2-w, -object.L/2, -object.lz/2];
  stop  = [object.L/2, object.L/2-g, object.lz/2];
  CSX = AddBox(CSX, material.name, priority+1, start, stop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  start = [-object.L/2+g, object.L/2-w-g,  -object.lz/2];
  stop  = [object.L/2, object.L/2-g, object.lz/2];
  CSX = AddBox(CSX, material.name, priority+1, start, stop, 
  'Transform', {'Rotate_Z', rotate, 'Translate', translate});
  ocenter = [object.xycenter(1:2), 0] + translate;
  params = ["# winding made of "  material.name " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n" \
            "# L, w, g = " num2str(L) ", " num2str(w) ", " num2str(g) ", background material " bmaterial.name "\n"];
  return;
endfunction;
