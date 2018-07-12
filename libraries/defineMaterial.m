function [CSX, param_str] = defineMaterial(CSX, material, param_str);
    % define a single material
  physical_constants;
  if strcmp(param_str, '');
        param_str = "# Definition of material properties: \n#";
  end;

    for [val, key] = material;
      param_str = horzcat(param_str, [key " = " num2str(val) ","]);
    end;
    param_str = horzcat(param_str, '\n' );
endfunction;