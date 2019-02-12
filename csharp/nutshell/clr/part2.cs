
using System;
using System.Collections;

namespace part2 {

class SomeClassWithConstant {
  public const int AGE = 10;
  public readonly int MAX_AGE = 100;
}

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

    // Implicit cast are enabled by c# compiler
    Int32 i = 5;
    Int64 l = i;
  }

  // 1. Primitive Type is just an alias in c#. Every primitive type maps to one FCL type.
  // 2. C# allows the programmer to decide how overflows should be handled. By default, overflow checking is turned off.
  static void TestPrimitives() {
    Int32 a = new System.Int32();
    int b = 0;

    Boolean c = new System.Boolean();
    bool d = false;

    Byte e = 100;
    e = checked((Byte)(e + 200));     // OverflowException is thrown

    checked {
      Byte f = 100;
      f += 200;
    }

    unchecked {
      Byte g = 100;
      g += 200;
    }
  }

  // The main advantage of value types is that they’re not allocated as objects in the managed heap.
  struct SomeValue { public int x; }
  class SomeRef { public int x; }
  static void TestValueTypeAndReferenceType() {
    SomeValue x1 = new SomeValue();
    SomeRef y1 = new SomeRef();

    x1.x = 5;
    y1.x = 5;

    SomeValue x2 = x1;
    SomeRef y2 = y1;
  }

  static void TestBox() {
    ArrayList c = new ArrayList();
    SomeValue x = new SomeValue();
    x.x = 1;
    c.Add(x);
    x.x = 2;
    c.Add(x);

    SomeValue y = (SomeValue)c[0];
  }

  // 1. constant is evaluated at compile time.
  // 2. constant is static and is always considered to be part of the defining type.
  // 3. constant does not have good cross-assembly version story.
  // 4. readonly field is a runtime constant
  // 5. updating public runtime constants is an implementation change, it is binary compatible with existing client code
  static void TestConstant() {
    int v = SomeClassWithConstant.AGE;
    SomeClassWithConstant o = new SomeClassWithConstant();
    int v2 = o.MAX_AGE;
  }
} // class cp4

} // namespace part2