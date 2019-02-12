
using System;

namespace part2 {

class cp4 {
  class Employ {}

  // 1. Prefer is/as than ()
  // 2. as is efficient than is
  static void TestTypeCast() {
    Object o = new Employ();

    // Explicit cast is not a preferred way. It can cause runtime error
    Employ e = (Employ)o;

    // The is operator checks whether an object is compatible with a given type,
    // and the result of the evaluation is a Boolean: true or false. The is operator will never throw an exception.
    Boolean v = o is Employ;

    // The as operator works just as casting does except that the as operator
    // will never throw an excep- tion. Instead, if the object can’t be cast, the result is null. 
    e = o as Employ;
  }

  // Primitive Type is just an alias in c#. Every primitive type maps to one FCL type.
  static void TestPrimitives() {
    System.Int32 a = new System.Int32();
    int b = 0;

    System.Boolean c = new System.Boolean();
    bool d = false;
  }
}

}