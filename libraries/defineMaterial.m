function [CSX, param_str] = defineMaterial(CSX, material, param_str);
    % define a single material
  physical_constants;
  if strcmp(param_str, '');
        param_str = "# Definition of material properties: \n#";
  end;
    CSX = AddMaterial(CSX, material.name);
    
  for [val, key] = material;
      param_str = horzcat(param_str, [key " = " num2str(val) ","]);
      if ~(strcmp(key, 'name'));
          CSX = SetMaterialProperty(CSX, material.name, key, val);
      end;
  end;
  
    param_str = horzcat(param_str, '\n' );
endfunction;