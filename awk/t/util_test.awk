
@include "util"

BEGIN {
  arr[1] = "a"
  arr[2] = "b"
  arr[3] = "c"

  print join(arr, 1, 3)
}
