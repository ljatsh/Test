Table of Contents
=================

* [Matrix Operations](#matrix-operations)
  * [Theorem1](#theorem1)
  * [Theorem2](#theorem2)
  * [Warnings](#warnings)
  * [Theorem3](#theorem3)
* [The Inverse of a Matrix](#the-inverse-of-a-matrix)
  * [Theorem4](#theorem4)
  * [Theorem5](#theorem5)
  * [Theorem6](#theorem6)
* [Glossory](#glossory)
  * [Diagonal Matrix](#diagonal-matrix)
  * [Transpose](#transpose)
  * [Inverse Matrix](#inverse-matrix)
  * [Singular Matrix](#singular-matrix)
  * [Elementary Matrix](#elementary-matrix)

Matrix Operations
-----------------

The sum A + B is defined only when A and B are the same size
The multiplication of AB is a composite mapping of A and B

ROW-COLUMN RULE FOR COMPUTING AB

If the product AB is defined, then the entry in row i and column j of AB is the sum of the products of corresponding entries from row i of A and column j of B. If (AB)ij denotes the (i, j) entry in AB, and if A is an m * n matrix, then

```math
  (AB)ij = ai1b1j + ai2b2j + ... + ainbnj
```

Theorem1
--------

Let A, B, and C be matrices of the same size, and let r and s be scalars.

Commutative

* A + B = B + A

Associative

* (A + B) + C = A + (B + C)
* r(sA) = (rs)A

Distributive

* r(A + B) = rA + rB
* (r + s)A = rA + sA

Theorem2
--------

Let A be an m * n matrix, and let B and C have sizes for which the indicated sums and products are defined.

Associative

* A(BC) = (AB)C
* r(AB) = (rA)B = A(rB)

Distributive

* A(B + C) = AB + AC
* (A + B)C = AC + BC

Identity for matrix multiplication

* ImA = A = AIn

Warnings
--------

In general, fowllow statements are true:

* AB != BA
* If AB = AC, then B != C
* If AB = 0, the A != 0 and B != 0

Theorem3
--------

Let A and B denote matrices whose sizes are appropriate for the following sums and products.

1. (AT)T = A
2. (A + B)T = AT + BT
3. (rA)T = rAT
4. (AB)T = BTAT

[Back to TOC](#table-of-contents)

The Inverse of a Matrix
-----------------------

Theorem4
--------

Let A = |a b|
        |c d|,
If the det = ad - bc != 0,  then A is invertible and
A(-1) = (1/det) * |d -b|
                  |-c a|
If det 0, then A is not invertible.

Theorem5
--------

If A is an invertible n * n matrix, then for each b in Rn, the equation Ax=b has the unique solution x=A(-1)b

Theorem6
--------

If A is an invertible matrix:

a. A(-1) is invertible and [A(-1)](-1) = A
b. If A and B are n*n invertible matrices, then so is AB,and the inverse of AB is the product of the inverses of A and B in the reverse order. That is,

```math
  (AB)(-1) = B(-1)A(-1)
  (ABC)(-1) = C(-1)B(-1)A(-1)
```

c. If A is an invertible matrix, then so is AT, and the inverse of AT is the transpose of A(-1). That is,

```math
  (AT)(-1) = [A(-1)]T
```

[Back to TOC](#table-of-contents)

Glossory
--------

Diagonal Matrix
---------------

A diagonal matrix is a square n * n matrix whose nondiagonal entries are zero

Transpose
---------

Given an `m * n` matrix A, the transpose of A is the `n * m` matrix, denoted by AT, whose columns are formed from the corresponding rows of A

Inverse Matrix
--------------

Supporse A is a square matrix. If AC=CA=I, then C is the inverse matrix of A, and A is invertible.

Singular Matrix
---------------

A matrix that is not invertible

Elementary Matrix
------------------

An elementary matrix is one that is obtained by performing a single elementary row operation on an identity matrix.

[Back to TOC](#table-of-contents)