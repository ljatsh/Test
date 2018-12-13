
# generate a random integer >=1 and <=n
function rand_int(n) {
  return int(n * rand()) + 1
}

BEGIN {
  srand(100000)

  for (i=1; i<=10; i++)
    print rand_int(10)
}
