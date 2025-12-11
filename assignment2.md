# Computational Mechanics II (Fall 2025)

Assignment 2

Due Date: 11:59 pm, Dec 19th, 2025

Student Name: ____________________

Student ID: ____________________

---

## 1. Problem 1 (50%)

Implement the Finite Element method in Matlab for stress analysis of 2D linear elasticity plate problems by completing the predefined Matlab functions.

### (a) Completed Functions

Functions in `main.m`, `plot_results.m`, `quadplot.m` and `constitutive.m` are completed. `main.m` is the main program of the Matlab code, which shows the steps for a Finite Element analysis process. Read the code starting from `main.m` to understand the meaning of our data structures and follow the calling order of the subroutines.

* **`<span class="citation-61">main.m</span>`** **: Main program of the Matlab code **^1^^1^^1^^1^
* **`<span class="citation-60">plot_results.m</span>`** **: Plot the deformation field and pressure field **^2^
* **`<span class="citation-59">quadplot.m</span>`** **: Plot the quadrilateral meshes **^3^
* **`<span class="citation-58">constitutive.m</span>`** **: Calculate the strain, stress and the pressure **^4^

### (b) Functions to Implement

Implement the functions marked with " **TODO** " comments following the instructions in the code:

* **`<span class="citation-57">B_matrix.m</span>`** **: Formation of the B matrix **^5^^5^^5^^5^
* **`<span class="citation-56">Boundary_conditions.m</span>`** **: Set up the displacement boundary conditions **^6^^6^^6^^6^
* **`<span class="citation-55">Enforce_BC.m</span>`** **: Enforce the essential boundary conditions to degrees of freedoms **^7^^7^^7^^7^
* **`<span class="citation-54">fext_vector.m</span>`** **: Formation of the external force vector **^8^
* **`<span class="citation-53">g_center.m</span>`** **: Calculate the barycenter of each element **^9^^9^^9^^9^
* **`<span class="citation-52">generate_mesh.m</span>`** **: Generate the mesh, i.e., node coordinates and element connectivity table **^10^^10^^10^^10^
* **`<span class="citation-51">K_matrix.m</span>`** **: Develop the stiffness matrix **^11^^11^^11^^11^

### Data Structures Note

**The important data structures defined in the Matlab code are**^12^:

**1. Nodal Coordinates Matrix (**$x_a$**):**

$$
x_a = \begin{pmatrix}
x^{(1)} & y^{(1)} \\
x^{(2)} & y^{(2)} \\
\vdots & \vdots \\
x^{(N)} & y^{(N)}
\end{pmatrix}
$$

^13^

**2. Element Connectivity Table (**$elem$**):**

$$
elem = \begin{pmatrix}
I^{(1)} & J^{(1)} & \dots & K^{(1)} \\
I^{(2)} & J^{(2)} & \dots & K^{(2)} \\
\vdots & \vdots & \vdots & \vdots \\
I^{(M)} & J^{(M)} & \dots & K^{(M)}
\end{pmatrix}
$$

^14^

Where:

* **$x^{(i)}$** and **$y^{(i)}$** in **$x_a$** are the coordinates of node **$i \in \{1, 2, \dots, N\}$**^15^.
* **$\{I^{(q)}, J^{(q)}, \dots, K^{(q)}\}$** are the indices of the nodes of element **$q \in \{1, 2, \dots, M\}$** (i.e., `<span class="citation-46">elem</span>` is the connectivity table)^16^.
* **$x^{(q)}$** and **$y^{(q)}$** in **$x_g$** are the coordinates of the barycenter of element **$q$**^17^.

### Matrix Definitions

The $B_M$ Matrix:

The $B_M$ matrix is defined as a Matlab cell structure. Based on the provided snippets, the structure implies a sparse definition involving derivatives and shape functions (Note: The OCR source is fragmented, but generally follows the standard B-matrix pattern similar to $B_N$ below)18181818.

The $B_N$ Matrix:

The $B_N$ matrix is defined as a Matlab cell structure:

$$
B_N(q) = \begin{pmatrix}
\frac{\partial N_I^{(q)}}{\partial x} & -N_I^{(q)} & 0 & \frac{\partial N_J^{(q)}}{\partial x} & -N_J^{(q)} & 0 & \dots & \frac{\partial N_K^{(q)}}{\partial x} & -N_K^{(q)} & 0 \\
\frac{\partial N_I^{(q)}}{\partial y} & 0 & -N_I^{(q)} & \frac{\partial N_J^{(q)}}{\partial y} & 0 & -N_J^{(q)} & \dots & \frac{\partial N_K^{(q)}}{\partial y} & 0 & -N_K^{(q)}
\end{pmatrix}
$$

**for **$q \in \{1, 2, \dots, M\}$^19^.

---

## 2. Problem 2 (50%)

**Consider a static linear elasticity isotropic plate problem on a thin plate as shown in Fig. 1. The problem involves a square thin plate with a side length of ****1 m** and a thickness of **0.05 m**^20^.

**Geometry and Setup:**

* **Dimensions:** **$1\text{m} \times 1\text{m}$** square.
* **Thickness:**$0.05\text{m}$^21^.
* **Boundary Conditions:** All four edges are pinned (i.e., deflection is fixed at 0)^22^.
* **Load:** A Gaussian distributed force is applied at the center^23^.

**Force Equation:**

$$
F = 10^6 * \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{R^2}{2\sigma^2}} \text{ (Pa)}
$$

**Where **$\sigma = 0.1$** and **$R$** denotes the distance from the plate center**^24^.

**Material Properties:**

* **Young's modulus: **$E = 210e9 \text{ Pa}$^25^.
* **Poisson's ratio: **$\nu = 0.3$^26^.

Plane Stress Condition:

The elastic moduli matrix is given by:

$$
C = \frac{E}{1-\nu^2} \begin{pmatrix}
1 & \nu & 0 \\
\nu & 1 & 0 \\
0 & 0 & \frac{1-\nu}{2}
\end{pmatrix}
$$

^27^.

### Tasks

**(a)** Discretize the domain using  **50, 200 and 5000 triangular elements** , respectively.

* *Hint:* Generate the meshes following the pattern shown in Fig. **2(a) and implement your algorithm in the Matlab function named **`<span class="citation-34">generate_mesh.m</span>`^28^.

**(b)** Discretize the domain using  **25, 100 and 2500 quadrilateral elements** , respectively.

* *Hint:* Generate the mesh following the pattern shown in Fig. **2(b) and implement your algorithm in the Matlab function named **`<span class="citation-33">generate_mesh.m</span>`^29^.

**(c)** Employ the Matlab code obtained from Problem 1 to solve for the **maximum rotation, deflection, stress, and strain distributions** across the problem domain^30^.

**(d)** Solve the problem in **Abaqus** or  **COMSOL** **, or other commercial software and validate your solution against the one obtained in commercial software by comparing the output field**^31^.
