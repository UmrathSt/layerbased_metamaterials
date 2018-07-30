function [CSX, param_str] = defineMaterials(CSX, material_list, param_str);
  physical_constants;
  param_str = "# Definition of material properties: \n#";
  for i = 1:(size(material_list)(2));
    for [val, key] = material_list{i};
      param_str = horzcat(param_str, [key " = " num2str(val) ","]);
    end;
    param_str = horzcat(param_str, "\n#");
    isdrude = 0;
    if strcmp(material_list{i}.name, "PEC");
      CSX = AddMetal(CSX, "PEC");
    elseif strcmp(material_list{i}.name, "FR4_Lorentz");
      %printf("Using Lorentz Oscillator Model for FR4. \n");
      CSX = AddLorentzMaterial(CSX, "FR4_Lorentz");
      CSX = SetMaterialProperty(CSX, "FR4_Lorentz", "Epsilon", 4.096, "Kappa", 2.294e-3, "EpsilonPlasmaFrequency", 8.84e9, "EpsilonRelaxTime", 7.96e-13);
      try; 
        CSX = SetMaterialProperty(CSX, "FR4_Lorentz", "Epsilon", material_list{i}.Epsilon);
      catch lasterror;
      end_try_catch;
    else;
      try;
        if strcmp(material_list{i}.type, "Drude");
          isdrude = 1;
          %printf("using Lorentz material");
          CSX = AddLorentzMaterial(CSX, material_list{i}.name);
          try;
            CSX = SetMaterialProperty(CSX, material_list{i}.name, 'EpsilonPlasmaFrequency', material_list{i}.EpsilonPlasmaFrequency,
                    'EpsilonRelaxTime', material_list{i}.EpsilonRelaxTime, 'Kappa', material_list{i}.Kappa, 'Epsilon', 1); # conductivity
          catch lasterror;
          end_try_catch;
          continue;
        else;
          CSX = AddMaterial(CSX, material_list{i}.name);
        endif;
      catch lasterror;
      end_try_catch;
      try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Kappa', material_list{i}.Kappa); # conductivity
      catch lasterror;
      end_try_catch;
      try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Epsilon', material_list{i}.Epsilon); # real Permittivity
      catch lasterror;
      end_try_catch;
      try;
          CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Kappa', material_list{i}.Epsilon*material_list{i}.tand*2*pi*EPS0*material_list{i}.f0); # real Permittivity
      catch lasterror;
      end_try_catch;
    endif;
  end;
endfunction;