function paramstring = get_geometry_info_string(object)
fields = fieldnames(object)
paramstring = ['# Parameters for object ', object.name, ': ']
for i = 2:size(fields, 1);
    display(['I am trying to add', fields{i,1}])
    paramstring = horzcat([paramstring, ', ', fields{i,1}, '=', num2str(object.(fields{i,1}))]);
end;
paramstring = horzcat(paramstring, '\n');
end