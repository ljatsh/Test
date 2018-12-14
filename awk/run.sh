#!/usr/bin/awk -f
@include "awkunit"

BEGIN {
    assertIO("t/util_test.awk", "/dev/stdin", "r/util_test.out")
    assertIO("t/random_test.awk", "/dev/stdin", "r/random_test.out")
    assertIO("t/cliche.awk", "t/cliche.in", "r/cliche.out")

    exit 0
}