#!/usr/bin/awk -f
@include "awkunit"

BEGIN {
    assertIO("t/random.awk", "/dev/stdin", "r/random.out")

    exit 0
}