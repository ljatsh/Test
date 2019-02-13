Table of Contents
=================

* [Type Fundamentals](#type-fundamentals)
  * [Casting Between Types](#casting-between-types)
* [Primitives, Reference and Value Types](#primitives-reference-and-value-types)
  * [Primitives](#primitives)
  * [Value Types](#value-types)
* [Consts and Fields](#consts-and-fields)
  * [Constant](#constant)
* [Methods](#methods)
  * [Constructor and Class](#constructor-and-class)
  * [Constructor and Value](#constructor-and-value)

Type Fundamentals
-----------------

1. All types are derived from System.Object

[Back to TOC](#table-of-contents)

Casting Between Types
---------------------

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

    // Implicit cast are enabled by c# compiler
    Int32 i = 5;
    Int64 l = i;
  }

  .method private hidebysig static void TestTypeCast() cil managed
  {
    // Code size 38
    .maxstack 2
    .locals init([System.Runtime]System.Object V_0, part2.cp4/Employ V_1, boolean V_2, int32 V_3, int64 V_4)
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
    IL_001f: ldc.i4.5
    IL_0020: stloc.3
    IL_0021: ldloc.3
    IL_0022: conv.i8
    IL_0023: stloc.s V_4
    IL_0025: ret
  } // End of method System.Void part2.cp4::TestTypeCast()
```

[Back to TOC](#table-of-contents)

Primitives, Reference and Value Types
------------------------------------

[Back to TOC](#table-of-contents)

Primitives
----------

```csharp
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

  .method private hidebysig static void TestPrimitives() cil managed
  {
    // Code size 59
    .maxstack 2
    .locals init(int32 V_0, int32 V_1, boolean V_2, boolean V_3, byte V_4, byte V_5, byte V_6)
    IL_0000: nop
    IL_0001: ldc.i4.0
    IL_0002: stloc.0
    IL_0003: ldc.i4.0
    IL_0004: stloc.1
    IL_0005: ldc.i4.0
    IL_0006: stloc.2
    IL_0007: ldc.i4.0
    IL_0008: stloc.3
    IL_0009: ldc.i4.s 100
    IL_000b: stloc.s V_4
    IL_000d: ldloc.s V_4
    IL_000f: ldc.i4 200
    IL_0014: add.ovf
    IL_0015: conv.ovf.u1
    IL_0016: stloc.s V_4
    IL_0018: nop
    IL_0019: ldc.i4.s 100
    IL_001b: stloc.s V_5
    IL_001d: ldloc.s V_5
    IL_001f: ldc.i4 200
    IL_0024: add.ovf
    IL_0025: conv.ovf.u1
    IL_0026: stloc.s V_5
    IL_0028: nop
    IL_0029: nop
    IL_002a: ldc.i4.s 100
    IL_002c: stloc.s V_6
    IL_002e: ldloc.s V_6
    IL_0030: ldc.i4 200
    IL_0035: add
    IL_0036: conv.u1
    IL_0037: stloc.s V_6
    IL_0039: nop
    IL_003a: ret
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

[Back to TOC](#table-of-contents)

Value Types
-----------

* Value type considerations:
  * The type doesn’t need to inherit from any other type.
  * The type won’t have any other types derived from it.
  * Immutable value type is preferred.
  * Value type is usually small. Otherwise, copy behavior can hurt its performance advantage.

```csharp
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

  .method private hidebysig static void TestValueTypeAndReferenceType() cil managed
  {
    // Code size 35
    .maxstack 2
    .locals init(part2.cp4/SomeValue V_0, part2.cp4/SomeRef V_1, part2.cp4/SomeValue V_2, part2.cp4/SomeRef V_3)
    IL_0000: nop
    IL_0001: ldloca.s V_0
    IL_0003: initobj part2.cp4/SomeValue
    IL_0009: newobj instance void part2.cp4/SomeRef::.ctor()
    IL_000e: stloc.1
    IL_000f: ldloca.s V_0
    IL_0011: ldc.i4.5
    IL_0012: stfld int32 part2.cp4/SomeValue::x
    IL_0017: ldloc.1
    IL_0018: ldc.i4.5
    IL_0019: stfld int32 part2.cp4/SomeRef::x
    IL_001e: ldloc.0
    IL_001f: stloc.2
    IL_0020: ldloc.1
    IL_0021: stloc.3
    IL_0022: ret
  } // End of method System.Void part2.cp4::TestValueTypeAndReferenceType()
```

[Back to TOC](#table-of-contents)

Consts and Fields
-----------------

[Back to TOC](#table-of-contents)

Constant
--------

```csharp
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

  .class private auto ansi beforefieldinit part2.SomeClassWithConstant extends [System.Runtime]System.Object
  {
    .field public static int32 AGE
    .field public initonly int32 MAX_AGE

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 16
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: ldc.i4.s 100
      IL_0003: stfld int32 part2.SomeClassWithConstant::MAX_AGE
      IL_0008: ldarg.0
      IL_0009: call instance void [System.Runtime]System.Object::.ctor()
      IL_000e: nop
      IL_000f: ret
  } // End of method System.Void part2.SomeClassWithConstant::.ctor()
  } // End of class part2.SomeClassWithConstant

  .class private auto ansi beforefieldinit part2.cp4 extends [System.Runtime]System.Object
  {

  .method private hidebysig static void TestConstant() cil managed
  {
    // Code size 18
    .maxstack 1
    .locals init(int32 V_0, part2.SomeClassWithConstant V_1, int32 V_2)
    IL_0000: nop
    IL_0001: ldc.i4.s 10
    IL_0003: stloc.0
    IL_0004: newobj instance void part2.SomeClassWithConstant::.ctor()
    IL_0009: stloc.1
    IL_000a: ldloc.1
    IL_000b: ldfld int32 part2.SomeClassWithConstant::MAX_AGE
    IL_0010: stloc.2
    IL_0011: ret
  } // End of method System.Void part2.cp4::TestConstant()
```

[Back to TOC](#table-of-contents)

Methods
-------

Constructor and Class
---------------------

* Initializers are executed first
* Base class constructor is then executed later
* Constructor logic is excuted lately
* this() is preferred to called to avoid instruction duplicates

```csharp
  class ClassMethod {
    private float field1 = 1.0f;
    private int field2;
    private string field3;

    public ClassMethod() {
      field2 = 1;
      field3 = "lj@sh";
    }

    public ClassMethod(int field2): this() {
      this.field2 = field2;
    }
  }

  .class private auto ansi beforefieldinit part2.ClassMethod extends [System.Runtime]System.Object
  {
    .field private single field1
    .field private int32 field2
    .field private string field3

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 38
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: ldc.r4 1
      IL_0006: stfld single part2.ClassMethod::field1
      IL_000b: ldarg.0
      IL_000c: call instance void [System.Runtime]System.Object::.ctor()
      IL_0011: nop
      IL_0012: nop
      IL_0013: ldarg.0
      IL_0014: ldc.i4.1
      IL_0015: stfld int32 part2.ClassMethod::field2
      IL_001a: ldarg.0
      IL_001b: ldstr "lj@sh"
      IL_0020: stfld string part2.ClassMethod::field3
      IL_0025: ret
    } // End of method System.Void part2.ClassMethod::.ctor()

    .method public hidebysig specialname rtspecialname instance void .ctor(int32 field2) cil managed
    {
      // Code size 16
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void part2.ClassMethod::.ctor()
      IL_0006: nop
      IL_0007: nop
      IL_0008: ldarg.0
      IL_0009: ldarg.1
      IL_000a: stfld int32 part2.ClassMethod::field2
      IL_000f: ret
    } // End of method System.Void part2.ClassMethod::.ctor(System.Int32)
  } // End of class part2.ClassMethod
```

[Back to TOC](#table-of-contents)

Constructor and Value
---------------------

* C# does not generate parameterless constructor, and parameterless constructor is forbidden in C#
* Intializer is not allowed
* Value type fields are guaranteed to be 0, if the value type is nested in reference type
* Stack-based value fields are not guaranteed to be 0, you should call parameterless constructor explicitly to guarantee it

[Back to TOC](#table-of-contents)
