Table of Contents
=================

* [Matrix Operations](#matrix-operations)
  * [Theorem1](#theorem1)
  * [Theorem2](#theorem2)
  * [Warnings](#warnings)
  * [Theorem3](#theorem3)
* [Glossory](#glossory)
  * [Diagonal Matrix](#diagonal-matrix)
  * [Transpose](#transpose)

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

[Back to TOC](#table-of-contents)

Theorem3
--------

Let A and B denote matrices whose sizes are appropriate for the following sums and products.

1. (AT)T = A
2. (A + B)T = AT + BT
3. (rA)T = rAT
4. (AB)T = BTAT

Glossory
--------

Diagonal Matrix
---------------

A diagonal matrix is a square n * n matrix whose nondiagonal entries are zero

Transpose
---------

Given an `m * n` matrix A, the transpose of A is the `n * m` matrix, denoted by AT, whose columns are formed from the corresponding rows of A

[Back to TOC](#table-of-contents)