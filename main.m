% main routine
% FEM code for Mindlin Plate Bending (Assignment 2, Problem 2)
% Refactored for 3 DOFs per node (w, theta_x, theta_y)

clear

flag=1;   % 1: triangular element;   2: quadrilateral element.

% 1. Generatemesh, initialize the coordinates of nodes and element
%    connectivity table

    % x_a is a [Nx2] matrix, N is the total number of nodes
    % elem is a [Mx3] matrix for triangular elements and [Mx4] matrix for
    % quadrilateral elements, M is the total number of elements
    nx = 10; ny = 10; % Mesh density
    [x_a,elem]=generate_mesh(flag, nx, ny);
        
    % Check the initial mesh
    if flag==1        
        triplot(elem,x_a(:,1),x_a(:,2));
    elseif flag==2
        quadplot(elem,x_a(:,1),x_a(:,2));
    end
    
    % Area and geometric center
    % xg is a [Mx2] matrix, M is the total number of elements
    % Area is a vector with M entries
    [xg,Area]=g_center(x_a,elem);

    [nodes,dim]=size(x_a);
    [elements,NNE]=size(elem);
    
    
 % 2. Boundary conditions
    % boundary: a vector with 3N entries (w, theta_x, theta_y)
    %           1 for constrained, 0 for free
    % dis     : a vector with 3N entries, prescribed values (usually 0)
    % Note: Pinned edges -> w=0, rotations free (Hard Support)
    [boundary,dis]=Boundary_conditions(x_a,elem);

% 3. Material Properties   
    E  = 210e9;   % Young's modulus [Pa]
    nu = 0.3;     % Poisson ratio
    t  = 0.05;    % Thickness [m]
    k  = 5/6;     % Shear correction factor
    
    properties(1)=E;
    properties(2)=nu;
    properties(3)=t;
    properties(4)=k;

% 4. K matrix: K is a 3Nx3N matrix
    % Assembles K_bending + K_shear
    % Internally calls B_matrix for integration points
    [K]=K_matrix(elem, x_a, properties, flag);

% 6. Forces vector: F is a vector with 3N entries
    % Gaussian Distributed Load: F = C * exp(-R^2 / (2*sigma^2))
    % Parameters: [Amplitude, sigma, center_x, center_y]
    LoadParams = [1e6, 0.1, 0.5, 0.5]; 
    [F]=F_vector(x_a, elem, LoadParams, flag);

% 7. Enforce Essential Boundary Condition
    [F,K]=Enforce_BC(F,K,boundary,dis);
    
% 8. Solve the problem
    [u]=K\F;
    
% 9. Compute Moments and Shears
    % Es: Curvatures and Shear Strains
    % Ss: Moments (Mx, My, Mxy) and Shear Forces (Qx, Qy)
    [Es,Ss]=constitutive(elem, x_a, properties, u, flag);

% 10. Post-processor    
    h=1; % amplification factor for deflection
    % Plot deflection w and maybe moments
    plot_results(x_a,elem,u,h,flag);

    save DATA Es Ss u














