% Set up the boundary conditions
% input:
% x_a: the coordinates of all the nodes
% elem: connectivity table
% output:
% boundary: boolean flag for each nodal displacement in x and y direction, 1 for constrained, 0 for free
% dis: prescribed nodal displacement in x and y direction
% l_area: surface area for each node
function [boundary,dis,l_area]=Boundary_conditions(x_a,elem)

    
    % Displacements imposition
    % Note: this method only works for straight line boundaries
    % parallel to the coordinate axis
    % 1st col: axis label 1 for x, 2 for y
    % 2nd col: location
    % 3rd col: 1 for displacement in x, 2 for y, and 3 for in both x and y
    %          direction
    % 4th col: value of the prescribed displacement
    % 
    % e.g apply displacement boundary condition on the edge of the domain at
    % x=1.5, u(1.5, y)=(0.0 10.0)  ->  (1, 1.5, 2, 10.0)
        
        A(1,:)=[1 0 3 0];        
        [boundary,dis]=displa(x_a,A);
        
    % Forces imposition (area of the nodes) 
    % Note: this method only works for straight line boundaries
    % parallel to the coordinate axis
    % 1st col: axis label 1 for x, 2 for y
    % 2nd col: location
    % 
    % e.g apply traction boundary conditions to the edge of the domain at
    % x=0  ->  (1,0)
		%_ Traction is applied on the top horizontal, y=y_max
        B(1,:)=[2 max(x_a(:,2))];   
        [l_area]=dist(x_a,elem,B);
end

% Set up the displacement boundary conditions in this function
% input:
% x_a: coordinates of all the nodes
% A: prescribed displacement boundary condition
% output:
% boundary: boolean flag for each nodal displacement in x and y direction, 1 for constrained, 0 for free
% disp: prescribed nodal displacement in x and y direction
function [boundary,dis]=displa(x_a,A)
    
    % TODO: Complete this function    

end

% Calculate the surface area associated with each node
% If the node is not a surface node and does not belong to the Neumann 
% boundary conditions, its surface area is initialized as 0
% input: 
% x_a: coordinates of all the nodes
% elem: connectivity table
% B: prescribed traction boundary condition
% output:
% l_area: the surface area associated to each node
function [l_area]=dist(x_a,elem,B)

    % TODO: Complete this function

end