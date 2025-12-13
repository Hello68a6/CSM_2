# CSM_2 Project Instructions (Mindlin Plate Refactoring)

## Project Status: Refactoring Complete
The project has been successfully refactored from a Plane Stress solver to a **Mindlin-Reissner Plate Bending Solver**.
It is now configured to solve **Assignment 2, Problem 2** (Pinned Plate with Gaussian Load).

## Physics & Theory (Mindlin Plate)
*   **Primary Variables**: 3 DOFs per node:
    1.  $w$: Transverse deflection (z-direction).
    2.  $\theta_x$: Rotation about y-axis.
    3.  $\theta_y$: Rotation about x-axis.
*   **Stiffness Components**:
    *   **Bending ($K_b$)**: Full Integration (2x2 Gauss for Quad4).
    *   **Shear ($K_s$)**: **Reduced Integration** (1x1 Gauss for Quad4) to prevent shear locking.
*   **Load**: Gaussian Distributed Transverse Load $q(x,y) = C \cdot e^{-R^2/2\sigma^2}$.
    *   Implemented via numerical integration in `F_vector.m`.
    *   Load is applied downwards ($C = -10^6$).

## Current Architecture
All source code is now located in the `src/` directory.

1.  **`src/main.m`**:
    *   **Automated Workflow**: Loops through Element Types (Tri3, Quad4) and Mesh Densities (5x5, 10x10, 50x50).
    *   **Orchestration**: Calls mesh generation, assembly, BC enforcement, solver, and post-processing.
2.  **`src/generate_mesh.m`**:
    *   Accepts `nx`, `ny` arguments for variable mesh density.
3.  **`src/Boundary_conditions.m`**:
    *   Enforces **Pinned Edges** ($w=0$) on all 4 sides.
    *   Rotations are free (Hard Support).
4.  **`src/B_matrix.m`**:
    *   Returns Bending ($B_b$) and Shear ($B_s$) matrices.
    *   Supports Tri3 and Quad4.
5.  **`src/K_matrix.m`**:
    *   Assembles $K = K_b + K_s$.
    *   Handles Reduced Integration logic internally.
6.  **`src/F_vector.m`**:
    *   Integrates Gaussian load over element area using shape functions.
7.  **`src/plot_results.m`**:
    *   Generates and saves visualization plots to `result/` directory (in project root).
    *   Plots: Deflection, Rotation, Von Mises Stress, Curvature, 3D Deformed Shape.

## Maintenance Notes
*   **Shear Locking**: If modifying element types or integration rules, ensure shear locking is prevented (usually by reduced integration or assumed shear strain fields).
*   **DOF Indexing**: Global DOFs are ordered `[w1, tx1, ty1, w2, tx2, ty2, ...]`.
*   **Results**: All outputs are directed to the `result/` folder in the project root to keep the source directory clean.

## Future Tasks
*   If "Soft Support" (tangential rotation constrained) is required, update `Boundary_conditions.m`.
*   If different load cases are needed, modify `LoadParams` in `main.m` or update `F_vector.m`.
