function meshlines = MeshFromCenters(center_coords, thickness, refinement);
%% Create a Smooth mesh from center positions of objects, their
%% thickness and the desired number of meshlines within the object.
assert(length(center_coords) == length(thickness));
assert(length(center_coords) == length(refinement));

for i = 1:length(center_coords);
    c = center_coords(i);
    d = thickness(i);
    n = refinement(i);
    

