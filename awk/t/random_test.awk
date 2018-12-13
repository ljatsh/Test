
@include "util"

# generate a random integer >=1 and <=n
function rand_int(n) {
  return int(n * rand()) + 1
}

# choose k elements from array in order
function choose(arr, n, k, ret,   i) {
  c = 1
  for (i=1; n>0; i++) {
    if (rand() < k/n--) {
      ret[c++] = arr[i]
      k--
    }
  }

  # TODO how to return array?
}

BEGIN {
  srand(100000)

  print "---test rand_int---"
  for (i=1; i<=10; i++)
    print rand_int(10)

  print "---test choose---"
  arr[1] = 1
  choose(arr, 1, 1, ret1)
  print join(ret1, 1, length(ret1))

  split("1,2,3,4,5,6,7,8,9,10", arr, ",")
  choose(arr, 10, 10, ret2)
  print join(ret2, 1, length(ret2))

  split("1,2,3,4,5,6,7,8,9,10", arr, ",")
  choose(arr, 10, 5, ret3)
  print join(ret3, 1, length(ret3))
}
