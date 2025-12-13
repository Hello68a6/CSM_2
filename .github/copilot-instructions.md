# CSM_2 Project Instructions (Mindlin Plate Refactoring)

## Project Overview
**MAJOR REFACTORING IN PROGRESS**: This project is being converted from a 2D Plane Stress solver to a **Mindlin-Reissner Plate Bending Solver** (First-order Shear Deformation Theory).
The goal is to solve Problem 2 of Assignment 2, which involves a thin plate with pinned edges under a Gaussian distributed transverse load.

## Physics & Theory (Mindlin Plate)
*   **Primary Variables**: 3 DOFs per node:
    1.  $w$: Transverse deflection (z-direction).
    2.  $\theta_x$: Rotation about y-axis (or rotation of normal in x-z plane).
    3.  $\theta_y$: Rotation about x-axis (or rotation of normal in y-z plane).
*   **Stiffness Components**:
    *   **Bending ($K_b$)**: Related to curvatures $\kappa$.
    *   **Shear ($K_s$)**: Related to transverse shear strains $\gamma$.
*   **Constitutive Matrices**:
    *   $D_b = \frac{Et^3}{12(1-\nu^2)} \begin{bmatrix} 1 & \nu & 0 \\ \nu & 1 & 0 \\ 0 & 0 & \frac{1-\nu}{2} \end{bmatrix}$ (Bending)
    *   $D_s = k G t \begin{bmatrix} 1 & 0 \\ 0 & 1 \end{bmatrix}$ (Shear), where $G = \frac{E}{2(1+\nu)}$ and $k=5/6$.

## Architecture & Workflow Changes
The file structure remains, but the logic within each file must change significantly.

1.  **`main.m`**:
    *   Update material properties ($E, \nu, t$).
    *   Update `Load` definition (now a function handle or parameters for Gaussian distribution).
    *   Ensure `K` and `F` are initialized with size `3*num_nodes`.
2.  **`generate_mesh.m`**:
    *   Existing logic is fine (2D geometry is unchanged).
3.  **`Boundary_conditions.m`**:
    *   **Pinned Edges**: Constrain $w=0$ on all four edges ($x=0, x=L, y=0, y=H$).
    *   Rotations $\theta_x, \theta_y$ are typically free for pinned edges (Hard support) or specific rotations might be constrained (Soft support). Assume Hard Support ($w=0$ only) unless specified.
4.  **`B_matrix.m`**:
    *   **Output**: Needs to return both Bending B-matrix ($B_b$) and Shear B-matrix ($B_s$).
    *   **Shape Functions**: Use Isoparametric formulation.
    *   **Integration**:
        *   **Bending**: Full integration (e.g., 2x2 Gauss for Quad4).
        *   **Shear**: **Reduced Integration** (e.g., 1x1 Gauss for Quad4) is crucial to prevent shear locking in thin plates.
5.  **`K_matrix.m`**:
    *   Assemble $K = \sum (K_b + K_s)$.
    *   $K_b = \int B_b^T D_b B_b dA$
    *   $K_s = \int B_s^T D_s B_s dA$
6.  **`F_vector.m`**:
    *   Implement **Gaussian Distributed Load**: $q(x,y) = C \cdot e^{-R^2/2\sigma^2}$.
    *   Compute equivalent nodal forces: $F_e = \int N^T q(x,y) dA$.
    *   Use numerical integration (Gauss quadrature) to integrate the load over each element.
7.  **`Enforce_BC.m`**:
    *   Update to handle 3 DOFs per node.
8.  **`constitutive.m` / Post-Processing**:
    *   Calculate Moments ($M_x, M_y, M_{xy}$) and Shear Forces ($Q_x, Q_y$).
    *   Compute Stresses ($\sigma_x, \sigma_y, \tau_{xy}$) at top/bottom surfaces ($z = \pm t/2$).

## Key Data Structures
*   **`K`**: `[3N x 3N]` Global stiffness matrix.
*   **`F`**: `[3N x 1]` Global force vector.
*   **`boundary`**: `[3N x 1]` Boolean vector.
*   **DOF Ordering**: Node $i$ has DOFs at indices `3*i-2` ($w$), `3*i-1` ($\theta_x$), `3*i` ($\theta_y$).

## Developer Workflow for Refactoring
1.  **Backup**: Ensure the original Plane Stress code is saved (e.g., in a separate folder or git branch).
2.  **Step-by-Step**:
    *   Start with `B_matrix.m` and `K_matrix.m` to implement Mindlin physics.
    *   Update `F_vector.m` for the Gaussian load.
    *   Update `Boundary_conditions.m` and `Enforce_BC.m` for 3 DOFs.
    *   Finally, update `main.m` to tie it all together.
3.  **Validation**:
    *   Test with a simple case first (e.g., uniform load) and compare with analytical solutions for Mindlin plates if possible.
    *   Then apply the Gaussian load.

## Common Pitfalls
*   **Shear Locking**: Using full integration for shear terms in thin plates will lead to overly stiff results. Use Reduced Integration for $K_s$.
*   **DOF Indexing**: Be very careful when mapping local element DOFs (1..12 for Quad4) to global DOFs.
*   **Load Integration**: The Gaussian load varies *within* the element. Do not just calculate it at the center; integrate it properly using shape functions.
