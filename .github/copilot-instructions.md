# CSM_2 Project Instructions

## Project Overview
This is a MATLAB-based Finite Element Analysis (FEA) solver for 2D linear elasticity problems. The project is structured as an assignment where specific core functions need to be implemented to complete the solver.

## Architecture & Workflow
The entry point is `main.m`, which orchestrates the FEA process in the following linear sequence:
1.  **Mesh Generation** (`generate_mesh.m`): Creates nodes (`x_a`) and connectivity (`elem`). Controlled by `flag` (1=Tri, 2=Quad).
    *   **Note**: Verify node winding order (Clockwise vs Counter-Clockwise) in `elem` as it affects signed area calculations in `g_center.m`. User indicates Quad elements are generated Clockwise.
2.  **Geometry Calculation** (`g_center.m`): Computes element centers (`xg`) and areas (`Area`).
3.  **Boundary Conditions** (`Boundary_conditions.m`): Defines constraints (`boundary`), prescribed displacements (`dis`), and nodal areas (`l_area`).
4.  **B Matrix Assembly** (`B_matrix.m`): Computes strain-displacement matrices. Returns `B` (cell array) and `p` (shape function values).
5.  **Stiffness Matrix Assembly** (`K_matrix.m`): Assembles the global stiffness matrix `K`. **(To be implemented)**
6.  **Force Vector Assembly** (`F_vector.m`): Assembles the global force vector `F`. **(To be implemented)**
7.  **BC Enforcement** (`Enforce_BC.m`): Modifies `K` and `F` for essential (displacement) boundary conditions. **(To be implemented)**
8.  **Solution**: Solves the linear system `u = K \ F`.
9.  **Post-processing** (`constitutive.m`, `plot_results.m`): Computes stresses/strains and visualizes results.

## Key Data Structures
*   **`x_a` (Nodes)**: `[N x 2]` matrix. Row `i` is `(x, y)` for node `i`.
*   **`elem` (Connectivity)**: `[M x 3]` (tri) or `[M x 4]` (quad) matrix. Row `e` contains node indices for element `e`. Verify winding order.
*   **`B` (Strain-Displacement)**: Cell array of size `[1 x M]`. `B{e}` is the B-matrix for element `e`.
*   **`properties`**: Vector `[E, nu]`. `E` = Young's Modulus, `nu` = Poisson's ratio.
*   **`K` (Stiffness)**: `[2N x 2N]` global stiffness matrix.
*   **`F` (Force)**: `[2N x 1]` global force vector.
*   **`boundary`**: `[2N x 1]` boolean vector. `1` = constrained DOF, `0` = free.
*   **`dis`**: `[2N x 1]` vector of prescribed displacement values.
*   **`l_area`**: `[N x 1]` vector of nodal surface areas (for traction calculation).

### Degree of Freedom (DOF) Ordering
DOFs are interleaved by node:
*   Index `2*i - 1`: x-displacement of node `i` ($u_i$)
*   Index `2*i`: y-displacement of node `i` ($v_i$)
*   Total DOFs = $2 \times N$.

## Implementation Guidelines

### Stiffness Matrix (`K_matrix.m`)
*   **Material Matrix (D)**: Implement **Plane Stress** assumption (consistent with `constitutive.m`).
    $$ D = \frac{E}{1-\nu^2} \begin{bmatrix} 1 & \nu & 0 \\ \nu & 1 & 0 \\ 0 & 0 & \frac{1-\nu}{2} \end{bmatrix} $$
*   **Assembly**:
    *   Initialize `K = zeros(2*num_nodes)`.
    *   Loop over elements `e`.
    *   Retrieve `Be = B{e}` and `Ae = Area(e)`.
    *   Compute element stiffness: `Ke = Be' * D * Be * Ae`. (Assume unit thickness).
    *   Assemble `Ke` into global `K` using indices from `elem(e, :)`.

### Force Vector (`F_vector.m`)
*   **Traction**: Apply traction `Load` to nodes with non-zero `l_area`.
*   **Calculation**: For node `i`, force components are `Load(1) * l_area(i)` and `Load(2) * l_area(i)`.
*   **Assembly**: Map to global DOFs `2*i-1` and `2*i`.

### Boundary Conditions (`Enforce_BC.m`)
*   **Direct Substitution Method**:
    *   Loop through all DOFs `j = 1:2*num_nodes`.
    *   If `boundary(j) == 1`:
        *   `K(j, :) = 0` (Zero out row)
        *   `K(:, j) = 0` (Zero out column - optional but good for symmetry)
        *   `K(j, j) = 1` (Set diagonal to 1)
        *   `F(j) = dis(j)` (Set RHS to prescribed value)
        *   *Note*: If zeroing columns, adjust `F` to account for known displacements affecting other equations: `F = F - K_column_j * dis(j)`. If `dis(j) == 0`, this is not needed.

## Development Workflow
*   **Run Simulation**: Execute `main.m`.
*   **Switch Elements**: Modify `flag=1` (Tri) or `flag=2` (Quad) in `main.m`.
*   **Visualization**: `plot_results.m` is called automatically. Use `triplot` or `quadplot` for mesh debugging.
*   **Data Persistence**: Results are saved to `DATA.mat`.
