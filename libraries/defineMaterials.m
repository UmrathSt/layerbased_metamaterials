function [CSX, param_str] = defineMaterials(CSX, material_list, param_str);
  physical_constants;
  param_str = '# Definition of material properties: \n#';
  for i = 1:size(material_list,2);
      m_mat = material_list{i};
      parameter_names = fieldnames(m_mat);
      keys = parameter_names{:,1};
    for i_key = 1:size(parameter_names,1)
        key = parameter_names{i_key,1};
        param_str = strcat(param_str, key, ' = ', num2str(m_mat.(key)), ',');
    end;
    param_str = horzcat(param_str, '\n#');
    isdrude = 0;
    if(strcmp(material_list{i}.name, 'PEC'))
      CSX = AddMetal(CSX, 'PEC');
    elseif(strcmp(material_list{i}.name, 'FR4_Lorentz'))
      %printf('Using Lorentz Oscillator Model for FR4. \n');
      CSX = AddLorentzMaterial(CSX, 'FR4_Lorentz');
      CSX = SetMaterialProperty(CSX, 'FR4_Lorentz', 'Epsilon', 4.096, 'Kappa', 2.294e-3, 'EpsilonPlasmaFrequency', 8.84e9, 'EpsilonRelaxTime', 7.96e-13);
      try; 
        CSX = SetMaterialProperty(CSX, 'FR4_Lorentz', 'Epsilon', material_list{i}.Epsilon);
      catch lasterror;
    end;
    else;
    if strcmp(material_list{i}.type, 'sheet');
      fprintf('entering sheet case \n');
      D = 0;
      Kappa = 56e6;
      try;
        D = material_list{i}.sheet_thickness;
      catch lasterror;
      end;
      try;
       Kappa = material_list{i}.Kappa;
      catch lasterror;
      end;
      CSX = AddConductingSheet(CSX, material_list{i}.name, Kappa, D);
   elseif(strcmp(material_list{i}.type, 'const'));
      %fprintf(strcat('Using Material with frequency independent epsilon/conducivity for ', material_list{i}.name, '\n'));
      CSX = AddMaterial(CSX, material_list{i}.name);
      try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Kappa', material_list{i}.Kappa);
      catch lasterror;
      end;
      
      try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Epsilon', material_list{i}.Epsilon); % real Permittivity
      catch lasterror;
      end;
      try;
          CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Kappa', material_list{i}.Epsilon*material_list{i}.tand*2*pi*EPS0*material_list{i}.f0); % real Permittivity
          %fprintf(strcat('Using loss tangent for description of conductivity, f0 = ', num2str(material_list{i}.f0), '\n'));
      catch lasterror;
      end;
   % Use a Multi-Pole Lorentz-Model for the permittivity 
   elseif strcmp(material_list{i}.type, 'Lorentz');
   try;
     printf(['Using a ' num2str(numel(material_list{i}.fplasma)) '-Pole Lorentz material for: ' material_list{i}.name '\n']);
     CSX = AddLorentzMaterial(CSX, material_list{i}.name);
     try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Epsilon', material_list{i}.Epsilon);
     catch lasterror;
     end;
     try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'Kappa', material_list{i}.Kappa);
     catch lasterror;
     end;
     for ii = 1:numel(material_list{i}.fplasma);
        CSX = SetMaterialProperty(CSX, material_list{i}.name, ...
        ['EpsilonPlasmaFrequency_' num2str(ii)], material_list{i}.fplasma(ii),...
        ['EpsilonLorPoleFrequency_' num2str(ii)], material_list{i}.fpole(ii),...
        ['EpsilonRelaxTime_' num2str(ii)], material_list{i}.tau(ii)); 
     end;
   catch lasterror;
   end; 

    elseif strcmp(material_list{i}.type, 'Drude');
      isdrude = 1;
      printf(['using Lorentz material for: ' material_list{i}.name '\n']);
      CSX = AddLorentzMaterial(CSX, material_list{i}.name);
      try;
        CSX = SetMaterialProperty(CSX, material_list{i}.name, 'EpsilonPlasmaFrequency', material_list{i}.EpsilonPlasmaFrequency,...
                 'EpsilonRelaxTime', material_list{i}.EpsilonRelaxTime, 'Kappa', material_list{i}.Kappa, 'Epsilon', 1); % conductivity
      catch lasterror;
    end;
      continue;
      end;
  end;
      fprintf(['name: ' m_mat.name '\n']);
      end