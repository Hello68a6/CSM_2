# CSM_2: Mindlin Plate Bending Solver

## Project Overview
This project is a MATLAB-based Finite Element Analysis (FEA) solver for **Mindlin-Reissner Plates** (First-order Shear Deformation Theory). It was developed to solve **Assignment 2, Problem 2**, which involves analyzing a square plate with pinned edges under a Gaussian distributed transverse load.

The solver supports both **Triangular (Tri3)** and **Quadrilateral (Quad4)** elements and includes automated scripts for mesh convergence studies.

## Key Features
*   **Physics**: Mindlin Plate Theory (suitable for both thin and moderately thick plates).
*   **DOFs**: 3 Degrees of Freedom per node ($w, \theta_x, \theta_y$).
*   **Elements**:
    *   **Tri3**: 3-node linear triangle.
    *   **Quad4**: 4-node bilinear quadrilateral.
*   **Integration Strategy**:
    *   **Bending**: Full Integration (2x2 Gauss for Quad4).
    *   **Shear**: **Reduced Integration** (1x1 Gauss for Quad4) to prevent shear locking.
*   **Loading**: Gaussian Distributed Transverse Load $q(x,y) = C \cdot e^{-R^2/2\sigma^2}$.
    *   Load is integrated numerically over each element to ensure accurate nodal force distribution.
*   **Boundary Conditions**: Pinned edges ($w=0$) on all four sides (Hard Support).

## File Structure
All source code is located in the `src/` directory.

*   `src/main.m`: **Entry point**. Orchestrates the analysis, loops through mesh cases, and saves results.
*   `src/generate_mesh.m`: Generates structured meshes with variable density (`nx`, `ny`).
*   `src/K_matrix.m`: Assembles the global stiffness matrix ($K = K_b + K_s$).
*   `src/B_matrix.m`: Computes Bending ($B_b$) and Shear ($B_s$) strain-displacement matrices.
*   `src/F_vector.m`: Computes the global force vector by integrating the Gaussian load.
*   `src/Boundary_conditions.m`: Identifies boundary nodes and applies Pinned constraints.
*   `src/Enforce_BC.m`: Modifies $K$ and $F$ to enforce boundary conditions.
*   `src/constitutive.m`: Post-processing to calculate Moments ($M$) and Shear Forces ($Q$).
*   `src/plot_results.m`: Generates visualization plots (Deflection, Stress, etc.).
*   `src/g_center.m`: Helper to calculate element centroids.
*   `src/quadplot.m` / `src/triplot.m`: Mesh visualization helpers.

## How to Run
1.  Open MATLAB and navigate to the `src` directory:
    ```matlab
    >> cd src
    ```
2.  Run the `main.m` script:
    ```matlab
    >> main
    ```
3.  The script will automatically perform a **Mesh Convergence Study**:
    *   **Element Types**: Tri3, Quad4.
    *   **Mesh Densities**: 5x5, 10x10, 50x50.
4.  **Results**:
    *   All results are saved in the `result/` directory (located in the project root, one level up from `src`).
    *   Subfolders are named by case (e.g., `result/Quad4_50x50/`).
    *   Each folder contains:
        *   `DATA.mat`: Raw simulation data (`u`, `Es`, `Ss`, etc.).
        *   `1_Deflection_w.png`: Transverse deflection contour.
        *   `2_Rotation_Magnitude.png`: Rotation magnitude contour.
        *   `3_Stress_VonMises.png`: Von Mises stress distribution.
        *   `5_Deformed_Shape_3D.png`: 3D visualization of the deformed plate.

## Physics Parameters
*   **Plate Dimensions**: $L=1.0$ m, $H=1.0$ m.
*   **Thickness**: $t=0.05$ m.
*   **Material**: $E=210$ GPa, $\nu=0.3$.
*   **Shear Correction**: $k=5/6$.
*   **Load**: Gaussian distribution with $C=-10^6$ (downward), $\sigma=0.1$, centered at $(0.5, 0.5)$.

## Implementation Details
*   **Shear Locking Control**: The code explicitly uses reduced integration for the shear stiffness matrix in `K_matrix.m`. This is critical for Quad4 elements to avoid overly stiff behavior in the thin plate limit.
*   **Load Integration**: The Gaussian load is not applied as point loads. Instead, `F_vector.m` performs a numerical integration of the pressure field over the element area using shape functions.
