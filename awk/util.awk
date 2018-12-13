
# join.awk --- join an array into a string
# https://www.gnu.org/software/gawk/manual/html_node/Join-Function.html#Join-Function
function join(array, start, end, sep,   result, i) {
  if (sep == "")
    sep = " "
  else if (sep == SUBSEP) # magic value
    sep = ""
  result = array[start]
  for (i = start + 1; i <= end; i++)
    result = result sep array[i]
  return result
}
