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

* [Glossory](#glossory)
  * [Linear System](#linear-system)
  * [Solution Set](#solution-set)
  * [System Equivalent](#system-equivalent)
  * [Leading Entry](#leading-entry)
  * [RREF](#rref)
  * [Basic Variable](#basic-variable)
  * [Free Variable](#free-variable)

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

Glossary
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

[Back to TOC](#table-of-contents)
