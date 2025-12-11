% Debug script for generate_mesh.m

disp('----------------------------------------');
disp('Testing generate_mesh.m');
disp('----------------------------------------');

%% Test 1: Triangular Mesh (flag=1)
disp(' ');
disp('--- Testing Triangular Mesh (flag=1) ---');
flag = 1;
try
    [x_a, elem] = generate_mesh(flag);
    
    num_nodes = size(x_a, 1);
    num_elems = size(elem, 1);
    
    disp(['Generated ', num2str(num_nodes), ' nodes.']);
    disp(['Generated ', num2str(num_elems), ' elements.']);
    
    disp('First 5 nodes (x, y):');
    disp(x_a(1:min(5, num_nodes), :));
    
    disp('First 5 elements connectivity:');
    disp(elem(1:min(5, num_elems), :));
    
    % Basic validation
    if size(elem, 2) == 3
        disp('SUCCESS: Element connectivity has 3 columns (Triangles).');
    else
        disp(['ERROR: Element connectivity has ', num2str(size(elem, 2)), ' columns. Expected 3.']);
    end
    
catch ME
    disp(['ERROR in Triangular Mesh generation: ', ME.message]);
end

%% Test 2: Quadrilateral Mesh (flag=2)
disp(' ');
disp('--- Testing Quadrilateral Mesh (flag=2) ---');
flag = 2;
try
    [x_a, elem] = generate_mesh(flag);
    
    num_nodes = size(x_a, 1);
    num_elems = size(elem, 1);
    
    disp(['Generated ', num2str(num_nodes), ' nodes.']);
    disp(['Generated ', num2str(num_elems), ' elements.']);
    
    disp('First 5 nodes (x, y):');
    disp(x_a(1:min(5, num_nodes), :));
    
    disp('First 5 elements connectivity:');
    disp(elem(1:min(5, num_elems), :));
    
    % Basic validation
    if size(elem, 2) == 4
        disp('SUCCESS: Element connectivity has 4 columns (Quads).');
    else
        disp(['ERROR: Element connectivity has ', num2str(size(elem, 2)), ' columns. Expected 4.']);
    end
    
catch ME
    disp(['ERROR in Quadrilateral Mesh generation: ', ME.message]);
end

disp(' ');
disp('----------------------------------------');
disp('Debug complete.');
