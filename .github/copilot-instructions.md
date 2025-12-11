# CSM_2 Project Instructions

## Project Overview
This is a MATLAB-based Finite Element Analysis (FEA) solver for 2D linear elasticity problems. The project is structured as an assignment where specific core functions need to be implemented to complete the solver.

## Architecture & Workflow
The entry point is `main.m`, which orchestrates the FEA process in the following linear sequence:
1.  **Mesh Generation** (`generate_mesh.m`): Creates nodes and connectivity.
2.  **Geometry Calculation** (`g_center.m`): Computes element centers and areas.
3.  **Boundary Conditions** (`Boundary_conditions.m`): Defines constraints and loads.
4.  **B Matrix Assembly** (`B_matrix.m`): Computes strain-displacement matrices.
5.  **Stiffness Matrix Assembly** (`K_matrix.m`): Assembles the global stiffness matrix `K`.
6.  **Force Vector Assembly** (`F_vector.m`): Assembles the global force vector `F`.
7.  **BC Enforcement** (`Enforce_BC.m`): Modifies `K` and `F` for essential (displacement) boundary conditions.
8.  **Solution**: Solves the linear system `u = K \ F`.
9.  **Post-processing** (`constitutive.m`, `plot_results.m`): Computes stresses and visualizes results.

## Key Data Structures
Understanding these variable names is critical for all functions:

*   **`x_a` (Nodes)**: `[N x 2]` matrix of nodal coordinates. Row `i` is `(x, y)` for node `i`.
*   **`elem` (Connectivity)**: `[M x 3]` (tri) or `[M x 4]` (quad) matrix. Row `e` contains node indices for element `e`.
*   **`K` (Stiffness Matrix)**: `[2N x 2N]` global stiffness matrix.
*   **`F` (Force Vector)**: `[2N x 1]` global force vector.
*   **`boundary`**: `[2N x 1]` boolean vector. `1` indicates a constrained DOF, `0` is free.
*   **`dis`**: `[2N x 1]` vector of prescribed displacement values.
*   **`l_area`**: `[N x 1]` vector containing the surface area associated with each node (for traction calculation).

### Degree of Freedom (DOF) Ordering
DOFs are interleaved by node:
*   Index `2*i - 1`: x-displacement of node `i` ($u_i$)
*   Index `2*i`: y-displacement of node `i` ($v_i$)
*   Total DOFs = $2 \times N$.

## Implementation Guidelines

### Matrix Assembly
*   **Global Matrix Initialization**: Always pre-allocate `K` (e.g., `zeros(2*num_nodes)`) before looping.
*   **Element Loop**: Iterate through elements `e = 1:num_elements`.
    *   Extract node indices from `elem(e, :)`.
    *   Compute element stiffness matrix `k_el`.
    *   Map local DOFs to global DOFs using the interleaved ordering.
    *   Add `k_el` to the appropriate positions in `K`.

### Boundary Conditions
*   **Enforcement**: Modify `K` and `F` to enforce $u_j = \bar{u}_j$.
    *   Common method: Zero out row `j` and column `j` of `K`, set diagonal `K(j,j) = 1`, and set `F(j) = \bar{u}_j`.
    *   Adjust `F` for other equations to maintain symmetry if required, or use the penalty method if preferred (though direct substitution is implied by the structure).

### MATLAB Best Practices
*   Use vectorization for geometric calculations where possible.
*   Use `zeros`, `ones`, `eye` for initialization.
*   Use `\` (mldivide) for solving linear systems.

## Development Workflow
*   **Run**: Execute `main.m` in the MATLAB terminal to run the full simulation.
*   **Toggle Mesh**: Change `flag=1` (triangle) or `flag=2` (quadrilateral) in `main.m` to test different element types.
*   **Debug**: Use `plot_results.m` output to visually verify if deformations and stresses look physical.
