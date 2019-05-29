Table of Contents
=================

* [System of Linear Equations](#system-of-linear-equations)
  * [Elementary Row Operations](#elementary-row-operations)
* [Row Reduction and Echelon Forms](#row-reduction-and-echelon-forms)
  * [Theorem1](#theorem1)
  * [Pivot](#pivot)
  * [The Row Reduction Algorithm](#the-row-reduction-algorithm)
  * [Theorem2](#theorem2)
  * [Using Row Reduction to Resolve a Linear System](#using-row-reduction-to-resolve-a-linear-system)
* [Vector Equations](#vector-equations)
  * [Linear Comination](#linear-comination)
  * [Geometric Description](#geometric-description)
* [Matrix Equations](#matrix-equations)
  * [Theorem3](#theorem3)
  * [Theorem4](#theorem4)
  * [Theorem5](#theorem5)
  * [Row Vector Rule](#row-vector-rule)
* [Solution Sets of Linear Systems](#solution-sets-of-linear-systems)
  * [Homogeneous Systems](#homogeneous-systems)
  * [Theorem6](#theorem6)
  * [Parametric Vector Form](#parametric-vector-form)
* [Linear Independency](#linear-independency)
  * [Sets of One or Two Vectors](#sets-of-one-or-two-vectors)
  * [Sets of Two or More Vectors](#sets-of-two-or-more-vectors)
  * [Theorem7](#theorem7)
  * [Theorem8](#theorem8)
  * [Theorem9](#theorem9)
* [Introduction to Linear Transformation](#introduction-to-linear-transformation)
  * [Matrix Transformations](#matrix-transformations)
  * [Linear Transformation](#linear-transformation)
* [The Matrix of a Linear Transformation](#the-matrix-of-a-linear-transformation)
  * [Theorem10](#theorem10)
  * [Theorem11](#theorem11)
  * [Theorem12](#theorem12)
  * [Transformation Examples](#transformation-examples)

* [Glossory](#glossory)
  * [Linear System](#linear-system)
  * [Solution Set](#solution-set)
  * [System Equivalent](#system-equivalent)
  * [Leading Entry](#leading-entry)
  * [RREF](#rref)
  * [Basic Variable](#basic-variable)
  * [Free Variable](#free-variable)
  * [Commutative Law](#commutative-law)
  * [Associative Law](#associative-law)
  * [Distributive Law](#distributive-law)

* [Refrence](#reference)

System of Linear Equations
--------------------------

For a given linear system, the two fundamental questions is:

1. (**Existence**)Is the system consistent; that is,does at least one solution exist?
2. (**Uniqueness**)If a solution exists, is it the only one; that is,is the solution unique?

Elementary Row Operations
-------------------------

Elementary row operations do not change the solution set of a given linear system. Use row operations to eliminate unknowns one by one can simply the calculations.

1. (**Replacement**)Replace one row bythe sum of itself and a multiple ofanother row
2. (**Interchange**)Interchange two rows
3. (**Scaling**)Multiply all entries in a row by a nonzero constant

[Back to TOC](#table-of-contents)

Row Reduction and Echelon Forms
-------------------------------

A rectangular matrix is in echelon form (or row echelon form) if it has the following three properties:

1. All nonzero rows are above any rows of all zeros.
2. Each leading entry of a row is in a column to the right of the leading entry of the row above it.
3. All entries in a column below a leading entry are zeros.

If a matrix in echelon form satisfies the following additional conditions, then it is in reduced echelon form (or reduced row echelon form):

1. The leading entry in each nonzero row is 1.
2. Each leading 1 is the only non zero entry in its column.

Theorem1
--------

Uniqueness of the reduced echelon form(PROOF TODO)

Each matrix is row equivalent to one and only one reduced echelon matrix.

Pivot
-----

A pivot position in a matrix A is a location in A that corresponds to a leading 1 in the reduced echelon form of A. A pivot column is a column of A that contains a pivot position.

When row operations on a matrix produce an echelon form, further row operations to obtain the reduced echelon form do not change the positions of the leading entries.

The Row Reduction Algorithm
---------------------------

produce a matrix in echelon form:

1. address the leftmost pivot column(with at least nonzero entry)
2. select a nonzero entry in the pivot column as a pivot (pivot position is at the top of the matrix)
3. use row replacement operations to create zeros in all positions below the pivot.
4. Apply steps 1–3 to the submatrix that remains. Repeat the process until there are no more nonzero rows to modify

product a matrix in RREF for a given maxtrix in echelon form:

1. Beginning with the rightmost pivot and working upward and to the left, create zeros above each pivot. If a pivot is not 1, make it 1 by a scaling operation.

Theorem2
--------

Existence and Uniqueness Theorem

A linear system is consistent if and only if the rightmost column of the augmented matrix is not a pivot column—that is, if and only if an echelon form of the augmented matrix has no row of the form  
          ```[0 ... 0 b]```  withbnonzero  
If a linear system is consistent, then the solution set contains either (i) a unique solution, when there are no free variables, or (ii) infinitely many solutions, when there is at least one free variable.

Using Row Reduction to Resolve a Linear System
-----------------------------------------------

1. Write the augmented matrix of the system.
2. Use the row reduction algorithm to obtain an equivalent augmented matrixin echelon form. Decide whether the system is consistent. If there is no solution, stop; otherwise, go to the next step.
3. Continue row reduction to obtain the reduced echelon form.
4. Write the system of equations corresponding to the matrix obtained in step3.
5. Rewrite each nonzero equation from step 4 so that its one basic variable is expressed in terms of any free variables appearing in the equation.

[Back to TOC](#table-of-contents)

Vector Equations
----------------

Vector (m * 1 matrix) is an ordered number list, denoted by (u1, u2 ... um). Vector addition and multiplication statisfies [Commutative](#commutative-law), [Associative](#associative-law) and [Distributive](#distributive-law).

Linear Comination
-----------------

Given vectors v1, v2, ..., vp in Rn and given scalars c1, c2, ..., cp, the vector y defined by

```math
  y = c1v1 + c2v2 + ... + cpvp
```

is called a linear combination of v1, ..., vp with weights c1, ..., cp. All the combines of v1, ..., vp is denoted by Span{v1, ..., vp}.

One of the key ideas in linear algebra is to study the set of all vectors that can be generated or written as a linear combination of a fixed set {v1, ..., vp} of vectors.

Geometric Description
---------------------

Vectors in R2

* u is a point in the plane
* u + v statisfies Parallelogram Rule
* Span{u} is a line through the origin and u

Vectors in R3

* u is a piont in the space
* Span{u} is a line through the origin and u
* Span{u, v} is a plane determined by line{0, u} and line{0, v}

[Back to TOC](#table-of-contents)

Matrix Equations
----------------

linear combinations of vectors a1, a2, ..., an an can be view as the product of Matrix A (with column a1, a2, ..., an) and the weight vector

```math
  [a1 a2 ... an](x1 x2 ... xn) = x1a1 + x2a2 + ... + xnan
```

Theorem3
--------

If A is an m * n matrix, with columns a1, a2 ... an and if b is in Rm, the matrix equation

```math
                Ax = b
```

has the same solution set as the vector equation

```math
                x1a1 + x2a2 + ... + xnan = b
```

which, in turn, has the same solution set as the system of linear equations whose augmented matrix is

```math
                [a1 a2 ... an b]
```

Linear equations can be viewd as 1) matrix equation 2) vector equation or 3) a system of linear equations

Theorem4
--------

Let A be an m * n matrix. Then the following statements are logically equivalent. That is, for a particular A, either they are all true statements or they are all false.

a. For each b in Rm,the equation Ax=b has a solution.
b. Each b in Rm is a linear combination of the columns of A.
c. The columns of A span Rm.
d. A has a pivot position in everyrow.(The coefficient matrix)

Theorem5
--------

If A is an m * n matrix, u and v are vectors in Rn, and c is a scalar, then:

a. A(u + v) = Au + Av
b. A(cu) = c(Au)

Row Vector Rule
---------------

If A is n m * n matrix, x is a vector in Rn. For each value in b=Ax:

```math
  bi = aix1 + ai*x2 + ... + anxn
```

[Back to TOC](#table-of-contents)

Solution Sets of Linear Systems
-------------------------------

The homogeneous system Ax = 0 has a nontrivial solution if and only the equation has at least one free variable.

Theorem6
--------

Suppose the equation Ax=b (Nonhomogeneous System) is consistent for some given b, and let p be a solution. Then the solution set of Ax=b is the set of all vectors of the form w = p + vh, where vh is any solution of the homogeneous equation Ax=0.

Theorem 7 says that if Ax=b has a solution, then the solution set is obtained by translating the solution set of Ax=0, using any particular solution p of Ax=b for the translation.

Parametric Vector Form
----------------------

If we write solution set in vector combination form x = su + tv (s, t in R), we call the solution in **parametric vector form**.
Writing a solution set (of a consistent system) in parametric vector form:

1. Row reduce the augmented matrix to reduced echelon form.
2. Express each basic variable in terms of any free variables appearing in an equation.
3. Write a typical solution x as a vector whose entries depend on the free variables, if any.
4. Decomposex into a linear combination of vectors(with numeric entries)using the free variables as parameters (weight)

[Back to TOC](#table-of-contents)

Linear Independency
-------------------

An indexed set of vectors {v1, ..., vp} in Rn is said to be linearly independent if the vector equation

```math
              x1v1 + x2v2 + ... + xpvp = 0
```

has only the trivial solution. The set {v1, ..., vp} is said to be linearly dependent if there exist weights c1, ..., cp, not all zero, such that

```math
              c1v1 + c2v2 + ... + cpvp = 0
```

Or we can say:
The columns of a matrix A are linearly independent if and only if the equation Ax = 0 has only the trivial solution.

Sets of One or Two Vectors
--------------------------

A set of two vectors {v1, v2} is linearly dependent if at least one of the vectors is a multiple of the other. The set is linearly independent if and only if neither of the vectors is a multiple of the other.

In geometric terms, two vectors are linearly dependent if and only if they lie on the same line through the origin.

Sets of Two or More Vectors
---------------------------

Theorem7
--------

An indexed set S = {v1, ..., vp } of two or more vectos is linearly dependent if and only if one of vectors is a linear combination of the others.
In fact, if S is linearly dependent and v1 != 0, then some vj(with j > 1) is a linear combination of the preceding vectors.

Theorem7 is the characterization of linearly dependant sets.

Theorem8
--------

If a set contains more vectors than there are entries in each vector, then the set is linearly dependent. That is, any set {v1, ..., vp} in Rn is linearly dependent if p > n.

Theorem9
--------

If a set S = {v1, ..., vp} in Rn contains the zero vector, then the set is linearly dependent.

[Back to TOC](#table-of-contents)

Introduction to Linear Transformation
-------------------------------------

The equation Ax = b can be viewed as a combination of colums of matrix by weight vector x. If we think of A as an "actor", then Ax=b is an mapping from one domain to another.

A **transformation**(or **function** or **mapping**) T from Rn to Rm is a rule that assigns to each vector x in Rn, a vector T(x) in Rm. The set Rn is called the **domain** of T, and Rm is called the **codomain** of T.

Matrix Transformations
----------------------

For each x in Rn , T(x) is computed as Ax, where A is an m * n matrix. For simplicity, we sometimes denote such a matrix transformation by **x |-->  Ax**

Linear Transformation
---------------------

A transformation (or mapping) T is linear if:

1. T(u + v) = T(u) + T(v) for all u, v in the domain of T (similar to [Distributive](#distributive-law))
2. T(cu) = cT(u) for all scalars c and all u in the domain of T

These two properties lead easily to the following useful facts:

1. T(0) = 0
2. T(cu + dv) = cT(u) + dT(v) for all vectors in the domain of T and all scalars c, d
3. T(c1v1 + c2v2 + ... + cpvp) = c1T(v1) + c2T(v2) + ... + cpT(vp) ---> superposition principle

According to the definition, Matrix taanformation is a linear transformation

[Back to TOC](#table-of-contents)

The Matrix of a Linear Transformation
-------------------------------------

A mapping T: Rn --> Rm is said to be **onto** Rm if each b in Rm is the image of at least one x in Rn(**Existance**)
A mapping T: Rn --> Rm is said to be **one to one** if each b in Rm is the image of at most one x in Rn(**Uniqueness**)

Theorem10
---------

Let T: Rn --> Rm be a linear transformation. Then there exists a unique matrix A such that

```math
                      T(x) = Ax   for all x in Rn
```

In fact, A is the m * n matrix whose jth column is the vector T(ej), where ej is the jth column of the identity matrix in Rn:

```math
                      A = [T(e1) T(e2) ... T(en)]
```

Theorem11
---------

Let T: Rn --> Rm be a linear transformation. Then T is one-to-one if and only if the equation T(x)=0 has only the trivial solution.

Theorem12
---------

Let T: Rn --> Rm be a linear transformation, and let A be the standard matrix for T . Then:
a. T maps Rn onto Rm if and only if the columns of A span Rm;
b. T is one-to-one if and only if the columns of A are linearly independent.

Transformation Examples
-----------------------

assume x in R2

* contraction/dialation

```math
  x |--> rx
```

* rotation

```math
  x |--> |cos@ -sin@|x
         |sin@  cos@|
```

[Back to TOC](#table-of-contents)

Glossory
--------

Linear System
-------------

a collection of one or more linear equations involving the same variables

Solution Set
------------

All possible solutions of the linear system

System Equivalent
-----------------

Two linear systems are called equivalent if they have the same solution set

Leading Entry
-------------

a leading entry of a row refers to the leftmost nonzero entry (in a nonzero row)

RREF
----

row reduced echelon form

Basic Variable
--------------

The variables corresponding to pivot columns in the matrix are called basic variables.

Free Variable
--------------

The variables not corresponding to pivot columns in the matrix called free variables.

Commutative Law
---------------

operands order does not change the answer. For example ```a + b = b + a, a * b = b * a```

Associative Law
---------------

It does not matter how we group operands (for the same type operator). For example

```math
(a + b) + c = a + (b + c)
(a * b) * c = a * (b * c)
```

Distributive Law
----------------

```math
c * (a + b) = c * a + c * b
(a + b) * c = a * c + b * c
```

[Back to TOC](#table-of-contents)

Reference
---------

https://www.mathsisfun.com/associative-commutative-distributive.html
