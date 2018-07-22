
var o = {
  name: 'ljatsh',
  age: 34,
  sex: null,
  is_boy: true,
  number: 1/0,
  Nan: Number.NaN
}

var output = JSON.stringify(o)
console.log(output)

console.log(JSON.parse(output))

// parse a string from lua-cjson
// console.log(JSON.parse('{"infinity":Infinity,"name":"ljatsh","nan":NaN}'))

