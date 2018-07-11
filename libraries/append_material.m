function material_list = append_material(material_list, material, verbose=0);
% append a material to the cell-array material_list if 
% no material with the same name already exists
already_exists = 0;
for i = 1:length(material_list);
    already_exists = strcmp(material_list{i}.name, material.name);
end;

if ~(already_exists);
    material_list{end+1} = material;
    if verbose;
        printf(['appended material with name: ' material.name ' . \n']);
    end;
end;

end;