#! /usr/bin/awk -f

@include "util"

BEGIN {
  FS = ":"
  srand(100)
}

{
  x[NR] = $1
  y[NR] = $2
}

END {
  for (i=1; i<=10; i++) {
    print x[rand_int(NR)], y[rand_int(NR)]
  }
}
