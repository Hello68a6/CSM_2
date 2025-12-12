# CSM_2 Project Instructions

## Project Overview
MATLAB-based Finite Element Analysis (FEA) solver for 2D linear elasticity problems. The codebase implements a complete FEA pipeline from mesh generation to post-processing for Plane Stress problems using Triangular or Quadrilateral elements.

## Architecture & Workflow
The system follows a linear execution flow defined in `main.m`:
1.  **Mesh Generation** (`generate_mesh.m`): Generates grid-based meshes.
    *   `flag=1`: Triangular elements.
    *   `flag=2`: Quadrilateral elements.
2.  **Geometry** (`g_center.m`): Calculates element centroids (`xg`) and areas (`Area`).
3.  **Boundary Setup** (`Boundary_conditions.m`): Defines constraints and loads.
4.  **Assembly**:
    *   `B_matrix.m`: Computes strain-displacement matrices.
    *   `K_matrix.m`: Assembles global stiffness matrix `K`.
    *   `F_vector.m`: Assembles global force vector `F` from tractions.
5.  **BC Enforcement** (`Enforce_BC.m`): Applies essential boundary conditions using the Direct Substitution Method.
6.  **Solution**: Solves `u = K \ F`.
7.  **Post-Processing** (`constitutive.m`, `plot_results.m`): Computes stress/strain and visualizes.

## Key Data Structures
*   **`x_a`**: `[N x 2]` Nodal coordinates matrix.
*   **`elem`**: `[M x 3]` (Tri) or `[M x 4]` (Quad) Connectivity matrix.
*   **`K`**: `[2N x 2N]` Global stiffness matrix. Sparse structure preferred but implemented as dense.
*   **`F`**: `[2N x 1]` Global force vector.
*   **`boundary`**: `[2N x 1]` Boolean vector (1=Constrained, 0=Free).
*   **`dis`**: `[2N x 1]` Prescribed displacement values.
*   **`properties`**: `[E, nu]` (Young's Modulus, Poisson's Ratio).

## Conventions & Patterns
*   **DOF Ordering**: Interleaved. Node `i` has DOFs at `2*i-1` (x-dir) and `2*i` (y-dir).
*   **Element Winding**:
    *   Quads are generated **Clockwise** in `generate_mesh.m`.
    *   Area calculation in `g_center.m` handles winding via absolute value.
*   **Physics Assumptions**:
    *   **Plane Stress** formulation used in `K_matrix.m` and `constitutive.m`.
    *   **Unit Thickness** assumed for stiffness and force integration.
*   **BC Enforcement**:
    *   **Direct Substitution**: Rows/Cols of `K` are zeroed, diagonal set to 1.
    *   RHS `F` is modified to account for non-zero prescribed displacements affecting free DOFs.

## Developer Workflow
*   **Execution**: Run `main.m` to execute the full pipeline.
*   **Configuration**: Edit `flag` variable in `main.m` to switch between Triangle (1) and Quad (2) meshes.
*   **Debugging**:
    *   Use `triplot` (built-in) or `quadplot.m` (custom) to verify mesh connectivity.
    *   Check `DATA.mat` for saved results (`Es`, `Ss`, `P`, `u`).
*   **File Naming**: Note that file names use underscores (`K_matrix.m`) which may differ from assignment descriptions (`Kmatrix.m`).

## Common Tasks
*   **Modifying Mesh Density**: Adjust `nx` and `ny` in `generate_mesh.m`.
*   **Changing Loads**: Update `Load` vector in `main.m` (passed to `F_vector.m`).
*   **Material Changes**: Update `E` and `nu` in `main.m`.
