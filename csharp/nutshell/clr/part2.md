Table of Contents
=================

* [Type Fundamentals](1_tf)
  * [Casting Between Types](1_cbt)
* [Primitives, Reference and Value Types](2_prvt)
  * [Primitives](2_p)

1_tf
----

1. All types are derived from System.Object

1_cbt
-----

```csharp
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

  .method private hidebysig static void TestTypeCast() cil managed
  {
    // Code size 32
    .maxstack 2
    .locals init([System.Runtime]System.Object V_0, part2.cp4/Employ V_1, boolean V_2)
    IL_0000: nop
    IL_0001: newobj instance void part2.cp4/Employ::.ctor()
    IL_0006: stloc.0
    IL_0007: ldloc.0
    IL_0008: castclass part2.cp4/Employ
    IL_000d: stloc.1
    IL_000e: ldloc.0
    IL_000f: isinst part2.cp4/Employ
    IL_0014: ldnull
    IL_0015: cgt.un
    IL_0017: stloc.2
    IL_0018: ldloc.0
    IL_0019: isinst part2.cp4/Employ
    IL_001e: stloc.1
    IL_001f: ret
  } // End of method System.Void part2.cp4::TestTypeCast()
```

2_p
---

```csharp
  // Primitive Type is just an alias in c#. Every primitive type maps to one FCL type.
  static void TestPrimitives() {
    System.Int32 a = new System.Int32();
    int b = 0;

    System.Boolean c = new System.Boolean();
    bool d = false;
  }

  .method private hidebysig static void TestPrimitives() cil managed
  {
    // Code size 10
    .maxstack 1
    .locals init(int32 V_0, int32 V_1, boolean V_2, boolean V_3)
    IL_0000: nop
    IL_0001: ldc.i4.0
    IL_0002: stloc.0
    IL_0003: ldc.i4.0
    IL_0004: stloc.1
    IL_0005: ldc.i4.0
    IL_0006: stloc.2
    IL_0007: ldc.i4.0
    IL_0008: stloc.3
    IL_0009: ret
  } // End of method System.Void part2.cp4::TestPrimitives()
```

  Primitive Type | FCL Type | CLS-Compliant | Description
---------------- | ---------| ------------- | -----------
int | System.Int32 | Yes | Signed 32-bit value
long | System.Int64 | Yes | Signed 64-bit value
float | System.Single | Yes | IEEE 32-bit floating point value
double | System.Double | Yes | IEEE 64-bit floating point value
string | System.String | Yes | An array of characters
object | System.Object | Yes | Base type of all types
dynamic | System.Object | Yes | tbd

