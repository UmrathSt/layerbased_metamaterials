function paramstring = get_geometry_info_string(object)
fields = fieldnames(object)
paramstring = ['# Parameters for object ', object.name, ': ']
for i = 2:size(fields, 1);
    display(['I am trying to add', fields{i,1}])
    val = object.(fields{i,1});
    if ischar(val);
        paramstring = horzcat([paramstring, ', ', fields{i,1}, '=', object.(fields{i,1})]);
    else;
        paramstring = horzcat([paramstring, ', ', fields{i,1}, '=', num2str(object.(fields{i,1}))]);
    end;
end;
paramstring = horzcat(paramstring, '\n');
end