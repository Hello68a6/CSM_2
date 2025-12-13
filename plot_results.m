function plot_results(x_a,elem,u,h,flag)
    % Plot the transverse deflection w
    
    [num_nodes, ~] = size(x_a);
    
    % Extract w from global displacement vector u
    w = zeros(num_nodes, 1);
    for i = 1:num_nodes
        w(i) = u(3*i-2);
    end
    
    % Plot Deformed Mesh (3D)
    figure;
    % Use patch for both element types
    % Vertices: x, y, w*h
    patch('Faces', elem, 'Vertices', [x_a(:,1), x_a(:,2), w*h], ...
          'FaceColor', 'interp', 'CData', w, 'EdgeColor', 'k', 'FaceAlpha', 0.8);
          
    title(['Deformed Shape (Scale Factor: ' num2str(h) ')']);
    xlabel('X'); ylabel('Y'); zlabel('w');
    colorbar;
    view(3);
    axis equal;
    grid on;
    
    % Contour Plot (2D view)
    figure;
    patch('Faces', elem, 'Vertices', [x_a(:,1), x_a(:,2), zeros(size(w))], ...
          'FaceColor', 'interp', 'CData', w, 'EdgeColor', 'none');
          
    title('Transverse Deflection w Contour');
    xlabel('X'); ylabel('Y');
    colorbar;
    view(2);
    axis equal;
    axis([min(x_a(:,1)) max(x_a(:,1)) min(x_a(:,2)) max(x_a(:,2))]);
    
end
