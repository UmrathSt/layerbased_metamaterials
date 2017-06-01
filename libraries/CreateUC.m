function [CSX, params] = CreateUC(CSX, object, translate, rotate);
  ocenter = translate;
  params = ["# Unitcell size lx, ly, lz = " num2str(object.lx) ", " num2str(object.ly) ", " num2str(object.lz) " at center position x = " num2str(ocenter(1)) " y = " num2str(ocenter(2)) " z = " num2str(ocenter(3)) "\n"];
endfunction;