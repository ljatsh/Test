Table of Contents
=================

* [Type Fundamentals](#type-fundamentals)
  * [Casting Between Types](#casting-between-types)
* [Primitives, Reference and Value Types](#primitives-reference-and-value-types)
  * [Primitives](#primitives)
  * [Value Types](#value-types)
  * [Boxing and Unboxing](#boxing-and-unboxing)
  * [Prefer Immutable Value Type](#prefer-immutable-value-type)
* [Type and Member Basics](#type-and-member-basics)
  * [How CLR Calls Methods](#how-clr-calls-methods)
* [Consts and Fields](#consts-and-fields)
  * [Constant](#constant)
* [Methods](#methods)
  * [Constructor and Class](#constructor-and-class)
  * [Constructor and Value](#constructor-and-value)
  * [Type Constructor](#type-constructor)
  * [Operator Overload Methods](#operator-overload-methods)
  * [Conversation Opeartor Methods](#conversation-opeartor-methods)
  * [Extension Method](#extension-method)
* [Parameters](#parameters)
  * [Optional and Named Parameters](#optional-and-named-parameters)
  * [Passing Parameters by Reference to a Method](#passing-parameters-by-reference-to-a-method)
  * [Passing a Variable Number of Arguments to a Method](#passing-a-variable-number-of-arguments-to-a-method)
  * [Parameter and Return Type Guidelines](#parameter-and-return-type-guidelines)
* [Properties](#properties)
  * [Parameterless Properties](#parameterless-properties)
  * [Object and Collection Initializer](#object-and-collection-initializer)
    * [Object Initializer](#object-initializer)
    * [Collection Initializer](#collection-initializer)
  * [Anonymous Types](#anonymous-types)
* [Interfaces](#interfaces)
  * [Defining an Interface](#defining-an-interface)
  * [More About Calling Interface Methods](#more-about-calling-interface-methods)
  * [Explicit Interface Method Implementation](#explicit-interface-method-implementation)

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
char | System.Char | Yes | 16-bit Unicode character
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

Boxing and Unboxing
-------------------

1. Base.ToString cause boxing
2. Calling virtual method does not cause boxing
3. Calling a nonvirtual inherited method(GetType or MemberwiseClone) causes boxing. These methods requires this argument is a reference type.
4. Casting an unboxed instance of a value type to one of the type’s interfaces causes boxing

```csharp
  struct SomeValue : IComparable {
    public int x;

    public int CompareTo(object obj) {
      return 0;
    }

    public override string ToString() {
      return base.ToString();
    }
  }

  .method public hidebysig virtual instance string ToString() cil managed
  {
    // Code size 22
    .maxstack 1
    .locals init(string V_0)
    IL_0000: nop
    IL_0001: ldarg.0
    IL_0002: ldobj part2.SomeValue
    IL_0007: box part2.SomeValue
    IL_000c: call instance string [System.Runtime]System.ValueType::ToString()
    IL_0011: stloc.0
    IL_0012: br.s     IL_0014
    IL_0014: ldloc.0
    IL_0015: ret
  } // End of method System.String part2.SomeValue::ToString()

  static void TestBox() {
    ArrayList c = new ArrayList();
    SomeValue x = new SomeValue();
    x.x = 1;
    // box
    c.Add(x);
    x.x = 2;
    // box
    c.Add(x);

    // unbox
    SomeValue y = (SomeValue)c[0];

    // box while calling GetType
    x.GetType();

    // not box while calling ToString. However, Base.ToString cause boxing
    x.ToString();

    // box, interface is reference type
    IComparable v = x;
  }

  .method private hidebysig static void TestBox() cil managed
  {
    // Code size 104
    .maxstack 2
    .locals init([System.Runtime.Extensions]System.Collections.ArrayList V_0, part2.cp4/SomeValue V_1, part2.cp4/SomeValue V_2, [System.Runtime]System.IComparable V_3)
    IL_0000: nop
    IL_0001: newobj instance void [System.Runtime.Extensions]System.Collections.ArrayList::.ctor()
    IL_0006: stloc.0
    IL_0007: ldloca.s V_1
    IL_0009: initobj part2.cp4/SomeValue
    IL_000f: ldloca.s V_1
    IL_0011: ldc.i4.1
    IL_0012: stfld int32 part2.cp4/SomeValue::x
    IL_0017: ldloc.0
    IL_0018: ldloc.1
    IL_0019: box part2.cp4/SomeValue
    IL_001e: callvirt instance int32 [System.Runtime.Extensions]System.Collections.ArrayList::Add([System.Runtime]System.Object)
    IL_0023: pop
    IL_0024: ldloca.s V_1
    IL_0026: ldc.i4.2
    IL_0027: stfld int32 part2.cp4/SomeValue::x
    IL_002c: ldloc.0
    IL_002d: ldloc.1
    IL_002e: box part2.cp4/SomeValue
    IL_0033: callvirt instance int32 [System.Runtime.Extensions]System.Collections.ArrayList::Add([System.Runtime]System.Object)
    IL_0038: pop
    IL_0039: ldloc.0
    IL_003a: ldc.i4.0
    IL_003b: callvirt instance [System.Runtime]System.Object [System.Runtime.Extensions]System.Collections.ArrayList::get_Item(int32)
    IL_0040: unbox.any part2.cp4/SomeValue
    IL_0045: stloc.2
    IL_0046: ldloc.1
    IL_0047: box part2.cp4/SomeValue
    IL_004c: call instance [System.Runtime]System.Type [System.Runtime]System.Object::GetType()
    IL_0051: pop
    IL_0052: ldloca.s V_1
    IL_0054: constrained. part2.cp4/SomeValue
    IL_005a: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_005f: pop
    IL_0060: ldloc.1
    IL_0061: box part2.cp4/SomeValue
    IL_0066: stloc.3
    IL_0067: ret
  } // End of method System.Void part2.cp4::TestBox()
```

[Back to TOC](#table-of-contents)

Prefer Immutable Value Type
---------------------------

* C# does not allow you to change boxed value type
* Interface can be used to change boxed value type. However, we should avoid trick.

```csharp
  static void TestPreferImmutableValueType() {
    Point p = new Point(1, 1);

    Object o = p;
    // a new unboxed temporary variable is created by IL
    ((Point) o).Change(3, 3);
  }

  .method private hidebysig static void TestPreferImmutableValueType() cil managed
  {
    // Code size 35
    .maxstack 3
    .locals init(part2.cp4/Point V_0, [System.Runtime]System.Object V_1, part2.cp4/Point V_2)
    IL_0000: nop
    IL_0001: ldloca.s V_0
    IL_0003: ldc.i4.1
    IL_0004: ldc.i4.1
    IL_0005: call instance void part2.cp4/Point::.ctor(int32, int32)
    IL_000a: ldloc.0
    IL_000b: box part2.cp4/Point
    IL_0010: stloc.1
    IL_0011: ldloc.1
    IL_0012: unbox.any part2.cp4/Point
    IL_0017: stloc.2
    IL_0018: ldloca.s V_2
    IL_001a: ldc.i4.3
    IL_001b: ldc.i4.3
    IL_001c: call instance void part2.cp4/Point::Change(int32, int32)
    IL_0021: nop
    IL_0022: ret
  } // End of method System.Void part2.cp4::TestPreferImmutableValueType()
```

[Back to TOC](#table-of-contents)

Type and Member Basics
----------------------

How CLR Calls Methods
---------------------

1. Base.ToString in Class Type generates call instruction
2. Base.ToString in Value Type results in boxing. So avoid to call base method while override virtual methods.
3. Non-Virtual method calling in Class Type generates callvirt instruction(null pointer check in C#)
4. Non-Virtual method calling in Value type generates call instruction
5. Base root class is the operand of callvirt instruction. (Derived.ToString() == Object.ToString())
6. "Finally, if you were to call a value type’s virtual method virtually, the CLR would need to have a reference to the
   value type’s type object in order to refer to the method table within it. This requires boxing the value type".
   I cannot validate this conclusion in .net core 2.2.

```csharp
  class ClassMethodCalling {
    public int Method1(int i) { return i + 1; }

    public virtual int Method2(int i) { return i + 2; }

    public static int Method3(int i) { return i + 3; }

    public override String ToString() {
      return base.ToString();
    }
  }

  .method public hidebysig virtual instance string ToString() cil managed
  {
    // Code size 12
    .maxstack 1
    .locals init(string V_0)
    IL_0000: nop
    IL_0001: ldarg.0
    IL_0002: call instance string [System.Runtime]System.Object::ToString()
    IL_0007: stloc.0
    IL_0008: br.s     IL_000a
    IL_000a: ldloc.0
    IL_000b: ret
  } // End of method System.String part2.ClassMethodCalling::ToString()

  struct ValueMethodCalling {
    public int Method1(int i) { return i + 1; }

    public static int Method3(int i) { return i + 3; }

    public override String ToString() {
      return base.ToString();
    }
  }

  .method public hidebysig virtual instance string ToString() cil managed
  {
    // Code size 22
    .maxstack 1
    .locals init(string V_0)
    IL_0000: nop
    IL_0001: ldarg.0
    IL_0002: ldobj part2.ValueMethodCalling
    IL_0007: box part2.ValueMethodCalling
    IL_000c: call instance string [System.Runtime]System.ValueType::ToString()
    IL_0011: stloc.0
    IL_0012: br.s     IL_0014
    IL_0014: ldloc.0
    IL_0015: ret
  } // End of method System.String part2.ValueMethodCalling::ToString()

  static void TestMethodCalling() {
    ClassMethodCalling v1 = new ClassMethodCalling();
    v1.Method1(1);
    v1.Method2(2);
    v1.ToString();
    ClassMethodCalling.Method3(3);

    ValueMethodCalling v2 = new ValueMethodCalling();
    v2.Method1(1);
    ValueType v3 = v2;
    v3.ToString();
    v2.ToString();
    ValueMethodCalling.Method3(3);
  }

  .method private hidebysig static void TestMethodCalling() cil managed
  {
    // Code size 90
    .maxstack 2
    .locals init(part2.ClassMethodCalling V_0, part2.ValueMethodCalling V_1, [System.Runtime]System.ValueType V_2)
    IL_0000: nop
    IL_0001: newobj instance void part2.ClassMethodCalling::.ctor()
    IL_0006: stloc.0
    IL_0007: ldloc.0
    IL_0008: ldc.i4.1
    IL_0009: callvirt instance int32 part2.ClassMethodCalling::Method1(int32)
    IL_000e: pop
    IL_000f: ldloc.0
    IL_0010: ldc.i4.2
    IL_0011: callvirt instance int32 part2.ClassMethodCalling::Method2(int32)
    IL_0016: pop
    IL_0017: ldloc.0
    IL_0018: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_001d: pop
    IL_001e: ldc.i4.3
    IL_001f: call int32 part2.ClassMethodCalling::Method3(int32)
    IL_0024: pop
    IL_0025: ldloca.s V_1
    IL_0027: initobj part2.ValueMethodCalling
    IL_002d: ldloca.s V_1
    IL_002f: ldc.i4.1
    IL_0030: call instance int32 part2.ValueMethodCalling::Method1(int32)
    IL_0035: pop
    IL_0036: ldloc.1
    IL_0037: box part2.ValueMethodCalling
    IL_003c: stloc.2
    IL_003d: ldloc.2
    IL_003e: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_0043: pop
    IL_0044: ldloca.s V_1
    IL_0046: constrained. part2.ValueMethodCalling
    IL_004c: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_0051: pop
    IL_0052: ldc.i4.3
    IL_0053: call int32 part2.ValueMethodCalling::Method3(int32)
    IL_0058: pop
    IL_0059: ret
  } // End of method System.Void part2.cp4::TestMethodCalling()
```

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
* Initializer is not allowed except for static field
* Value type constructor is executed only when explicitly called!!!

[Back to TOC](#table-of-contents)

Type Constructor
----------------

* Never define type constructor in Value Type. I don't know why it was not called during testing.
* Type constructor is thread safe and will be called by CLR only once every AppDomain.

Operator Overload Methods
-------------------------

* CLR does not kown operator overload at all. Operator overload is compiler action.
* Primitive types does not define overloaded operators for performance reason.
* Overload operator method must be public and static.
* [System.Decimal](https://docs.microsoft.com/en-us/dotnet/api/system.decimal?view=netcore-2.2) is a good example.
* C# Unary Operators and Their CLS-Compilant Method Names:

C# Operator Symbol | Special Method Name | Suggested CLS-Compilant Method Name
------------------ | --------------------| -----------------------------------
`+` | op_UnaryPlus | Plus
`-` | op_UnaryNegation | Negate
`!`| op_LogicNot | Yes | Not
`~` | op_OnesComplement | OnesComplement
`++` | op_Increment | Yes | Increment
`--`| op_Decrement | Yes | Decrement
`(none)` | op_True | Yes | IsTrue { get; }
`(none)` | op_False | Yes | IsFalse { get; }

* C# Binary Operators and Their CLS-Compilant Method Names:

C# Operator Symbol | Special Method Name | Suggested CLS-Compilant Method Name
------------------ | --------------------| -----------------------------------
`+` | op_Addition | Add
`-` | op_Subtraction | Subtract
`*` | op_Multiply | Multiply
`/` | op_Division | Divide
`%` | op_Modulus | Mod
`&` | op_BitwiseAnd | BitwiseAnd
`|` | op_BitwiseOr | BitwiseOr
`^` | op_ExclusiveOr | Xor
`<<` | op_LeftShift | LeftShift
`>>` | op_RightShift | op_RightShift
`==` | op_Equality | Equals
`!=` | op_InEquality | Equals
`<` | op_LessThan | Compare
`>` | op_GreaterThan | Compare
`<=` | op_LessThanOrEqual | Compare
`>=` | op_GreaterThanOrEqual | Compare

```csharp
  class OperatorOverloadTest {
    public override bool Equals(object obj) {
      return false;
    }

    public override int GetHashCode() {
      return 1;
    }

    public static OperatorOverloadTest operator+(OperatorOverloadTest left, OperatorOverloadTest right) {
      return null;
    }

    public static bool operator==(OperatorOverloadTest left, OperatorOverloadTest right) {
      return false;
    }

    public static bool operator!=(OperatorOverloadTest left, OperatorOverloadTest right) {
      return true;
    }

    public static bool operator<(OperatorOverloadTest left, OperatorOverloadTest right) {
      return false;
    }

    public static bool operator>(OperatorOverloadTest left, OperatorOverloadTest right) {
      return false;
    }
  }

  .class private auto ansi beforefieldinit part2.OperatorOverloadTest extends [System.Runtime]System.Object
  {

    .method public hidebysig virtual instance boolean Equals([System.Runtime]System.Object obj) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(boolean V_0)
      IL_0000: nop
      IL_0001: ldc.i4.0
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Boolean part2.OperatorOverloadTest::Equals(System.Object)

    .method public hidebysig virtual instance int32 GetHashCode() cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(int32 V_0)
      IL_0000: nop
      IL_0001: ldc.i4.1
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Int32 part2.OperatorOverloadTest::GetHashCode()

    .method public hidebysig specialname static part2.OperatorOverloadTest op_Addition(part2.OperatorOverloadTest left, part2.OperatorOverloadTest right) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(part2.OperatorOverloadTest V_0)
      IL_0000: nop
      IL_0001: ldnull
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method part2.OperatorOverloadTest part2.OperatorOverloadTest::op_Addition(part2.OperatorOverloadTest,part2.OperatorOverloadTest)

    .method public hidebysig specialname static boolean op_Equality(part2.OperatorOverloadTest left, part2.OperatorOverloadTest right) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(boolean V_0)
      IL_0000: nop
      IL_0001: ldc.i4.0
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Boolean part2.OperatorOverloadTest::op_Equality(part2.OperatorOverloadTest,part2.OperatorOverloadTest)

    .method public hidebysig specialname static boolean op_Inequality(part2.OperatorOverloadTest left, part2.OperatorOverloadTest right) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(boolean V_0)
      IL_0000: nop
      IL_0001: ldc.i4.1
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Boolean part2.OperatorOverloadTest::op_Inequality(part2.OperatorOverloadTest,part2.OperatorOverloadTest)

    .method public hidebysig specialname static boolean op_LessThan(part2.OperatorOverloadTest left, part2.OperatorOverloadTest right) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(boolean V_0)
      IL_0000: nop
      IL_0001: ldc.i4.0
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Boolean part2.OperatorOverloadTest::op_LessThan(part2.OperatorOverloadTest,part2.OperatorOverloadTest)

    .method public hidebysig specialname static boolean op_GreaterThan(part2.OperatorOverloadTest left, part2.OperatorOverloadTest right) cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(boolean V_0)
      IL_0000: nop
      IL_0001: ldc.i4.0
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
     } // End of method System.Boolean part2.OperatorOverloadTest::op_GreaterThan(part2.OperatorOverloadTest,part2.OperatorOverloadTest)

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 8
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void [System.Runtime]System.Object::.ctor()
      IL_0006: nop
      IL_0007: ret
    } // End of method System.Void part2.OperatorOverloadTest::.ctor()
  } // End of class part2.OperatorOverloadTest

  static void TestOperatorOverload() {
    int v1 = 1;
    int v2 = 3;
    int v3 = v1 + v2;

    OperatorOverloadTest v4 = new OperatorOverloadTest();
    OperatorOverloadTest v5 = new OperatorOverloadTest();
    OperatorOverloadTest v6 = v4 + v5;
    var v7 = v4 == v5;
    v7 = v4 != v5;
    v7 = v4 < v5;
    v7 = v4 > v5;
  }

  .method private hidebysig static void TestOperatorOverload() cil managed
  {
    // Code size 73
    .maxstack 2
    .locals init(int32 V_0, int32 V_1, int32 V_2, part2.OperatorOverloadTest V_3, part2.OperatorOverloadTest V_4, part2.OperatorOverloadTest V_5, boolean V_6)
    IL_0000: nop
    IL_0001: ldc.i4.1
    IL_0002: stloc.0
    IL_0003: ldc.i4.3
    IL_0004: stloc.1
    IL_0005: ldloc.0
    IL_0006: ldloc.1
    IL_0007: add
    IL_0008: stloc.2
    IL_0009: newobj instance void part2.OperatorOverloadTest::.ctor()
    IL_000e: stloc.3
    IL_000f: newobj instance void part2.OperatorOverloadTest::.ctor()
    IL_0014: stloc.s V_4
    IL_0016: ldloc.3
    IL_0017: ldloc.s V_4
    IL_0019: call part2.OperatorOverloadTest part2.OperatorOverloadTest::op_Addition(part2.OperatorOverloadTest, part2.OperatorOverloadTest)
    IL_001e: stloc.s V_5
    IL_0020: ldloc.3
    IL_0021: ldloc.s V_4
    IL_0023: call boolean part2.OperatorOverloadTest::op_Equality(part2.OperatorOverloadTest, part2.OperatorOverloadTest)
    IL_0028: stloc.s V_6
    IL_002a: ldloc.3
    IL_002b: ldloc.s V_4
    IL_002d: call boolean part2.OperatorOverloadTest::op_Inequality(part2.OperatorOverloadTest, part2.OperatorOverloadTest)
    IL_0032: stloc.s V_6
    IL_0034: ldloc.3
    IL_0035: ldloc.s V_4
    IL_0037: call boolean part2.OperatorOverloadTest::op_LessThan(part2.OperatorOverloadTest, part2.OperatorOverloadTest)
    IL_003c: stloc.s V_6
    IL_003e: ldloc.3
    IL_003f: ldloc.s V_4
    IL_0041: call boolean part2.OperatorOverloadTest::op_GreaterThan(part2.OperatorOverloadTest, part2.OperatorOverloadTest)
    IL_0046: stloc.s V_6
    IL_0048: ret
  } // End of method System.Void part2.cp4::TestOperatorOverload()
```

[Back to TOC](#table-of-contents)

Conversation Opeartor Methods
-----------------------------

* ```public static implicit|explicit operator type1(type2) { return null; }```
* op_Implicit and op_Explicit methods are generated in CLR.
* User defined conversation operator is different from as/is.
* Base, Derived class conversation is now allowed. For example, ```public static implicit operator Object(Rational r) { return null; }```  
  causes error ```Rational.implicit operator object(Rational)': user-defined conversions to or from a base class are not allowed```

```csharp
  public sealed class Rational {
    // Constructs a Rational from an Int32
    public Rational(Int32 num) { }
    // Constructs a Rational from a Single
    public Rational(Single num) { }
    // Converts a Rational to an Int32
    public Int32 ToInt32() { return 1; }
    // Converts a Rational to a Single
    public Single ToSingle() { return 1.0f; }
    // Implicitly constructs and returns a Rational from an Int32
    public static implicit operator Rational(Int32 num) {
      return new Rational(num);
    }
    // Implicitly constructs and returns a Rational from a Single
    public static implicit operator Rational(Single num) {
      return new Rational(num);
    }
    // Explicitly returns an Int32 from a Rational
    public static explicit operator Int32(Rational r) {
      return r.ToInt32();
    }
    // Explicitly returns a Single from a Rational
    public static explicit operator Single(Rational r) {
      return r.ToSingle();
    }
  }

  .class public auto ansi sealed beforefieldinit part2.Rational extends [System.Runtime]System.Object
  {
    .method public hidebysig specialname rtspecialname instance void .ctor(int32 num) cil managed
    {
      // Code size 9
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void [System.Runtime]System.Object::.ctor()
      IL_0006: nop
      IL_0007: nop
      IL_0008: ret
    } // End of method System.Void part2.Rational::.ctor(System.Int32)

    .method public hidebysig specialname rtspecialname instance void .ctor(single num) cil managed
    {
      // Code size 9
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void [System.Runtime]System.Object::.ctor()
      IL_0006: nop
      IL_0007: nop
      IL_0008: ret
    } // End of method System.Void part2.Rational::.ctor(System.Single)

    .method public hidebysig instance int32 ToInt32() cil managed
    {
      // Code size 7
      .maxstack 1
      .locals init(int32 V_0)
      IL_0000: nop
      IL_0001: ldc.i4.1
      IL_0002: stloc.0
      IL_0003: br.s     IL_0005
      IL_0005: ldloc.0
      IL_0006: ret
    } // End of method System.Int32 part2.Rational::ToInt32()

    .method public hidebysig instance single ToSingle() cil managed
    {
      // Code size 11
      .maxstack 1
      .locals init(single V_0)
      IL_0000: nop
      IL_0001: ldc.r4 1
      IL_0006: stloc.0
      IL_0007: br.s     IL_0009
      IL_0009: ldloc.0
      IL_000a: ret
    } // End of method System.Single part2.Rational::ToSingle()

    .method public hidebysig specialname static part2.Rational op_Implicit(int32 num) cil managed
    {
      // Code size 12
      .maxstack 1
      .locals init(part2.Rational V_0)
      IL_0000: nop
      IL_0001: ldarg.0
      IL_0002: newobj instance void part2.Rational::.ctor(int32)
      IL_0007: stloc.0
      IL_0008: br.s     IL_000a
      IL_000a: ldloc.0
      IL_000b: ret
    } // End of method part2.Rational part2.Rational::op_Implicit(System.Int32)

    .method public hidebysig specialname static part2.Rational op_Implicit(single num) cil managed
    {
      // Code size 12
      .maxstack 1
      .locals init(part2.Rational V_0)
      IL_0000: nop
      IL_0001: ldarg.0
      IL_0002: newobj instance void part2.Rational::.ctor(single)
      IL_0007: stloc.0
      IL_0008: br.s     IL_000a
      IL_000a: ldloc.0
      IL_000b: ret
    } // End of method part2.Rational part2.Rational::op_Implicit(System.Single)

    .method public hidebysig specialname static int32 op_Explicit(part2.Rational r) cil managed
    {
      // Code size 12
      .maxstack 1
      .locals init(int32 V_0)
      IL_0000: nop
      IL_0001: ldarg.0
      IL_0002: callvirt instance int32 part2.Rational::ToInt32()
      IL_0007: stloc.0
      IL_0008: br.s     IL_000a
      IL_000a: ldloc.0
      IL_000b: ret
    } // End of method System.Int32 part2.Rational::op_Explicit(part2.Rational)

    .method public hidebysig specialname static single op_Explicit(part2.Rational r) cil managed
    {
      // Code size 12
      .maxstack 1
      .locals init(single V_0)
      IL_0000: nop
      IL_0001: ldarg.0
      IL_0002: callvirt instance single part2.Rational::ToSingle()
      IL_0007: stloc.0
      IL_0008: br.s     IL_000a
      IL_000a: ldloc.0
      IL_000b: ret
    } // End of method System.Single part2.Rational::op_Explicit(part2.Rational)
  } // End of class part2.Rational

  static void TestConversationOpearator() {
    Rational r1 = 5;         // Implicit cast from Int32  to Rational
    Rational r2 = 2.5F;      // Implicit cast from Single to Rational

    Int32  x = (Int32)  r1;  // Explicit cast from Rational to Int32
    Single s = (Single) r2;  // Explicit cast from Rational to Single
  }

  .method private hidebysig static void TestConversationOpearator() cil managed
  {
    // Code size 35
    .maxstack 1
    .locals init(part2.Rational V_0, part2.Rational V_1, int32 V_2, single V_3)
    IL_0000: nop
    IL_0001: ldc.i4.5
    IL_0002: call part2.Rational part2.Rational::op_Implicit(int32)
    IL_0007: stloc.0
    IL_0008: ldc.r4 2.5
    IL_000d: call part2.Rational part2.Rational::op_Implicit(single)
    IL_0012: stloc.1
    IL_0013: ldloc.0
    IL_0014: call int32 part2.Rational::op_Explicit(part2.Rational)
    IL_0019: stloc.2
    IL_001a: ldloc.1
    IL_001b: call single part2.Rational::op_Explicit(part2.Rational)
    IL_0020: conv.r4
    IL_0021: stloc.3
    IL_0022: ret
  } // End of method System.Void part2.cp4::TestConversationOpearator()
```

[Back to TOC](#table-of-contents)

Extension Method
----------------

refer [this](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/extension-methods)

* Extension Method generates ```call``` instruction. So null this is valid.
* Good Practice:
  * Prefer to add extension to interface instead of concreate class. Refer [System.Linq.Enumerable](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.all?view=netcore-2.2)
  * Prefer to use extension method to avoid dependency issue

```csharp
  static void TestExtensionMethod() {
    String o = null;
    o.Dump();
  }

  .method private hidebysig static void TestExtensionMethod() cil managed
  {
    // Code size 11
    .maxstack 1
    .locals init(string V_0)
    IL_0000: nop
    IL_0001: ldnull
    IL_0002: stloc.0
    IL_0003: ldloc.0
    IL_0004: call string part2.ExtensionClass::Dump([System.Runtime]System.Collections.IEnumerable)
    IL_0009: pop
    IL_000a: ret
  } // End of method System.Void part2.cp4::TestExtensionMethod()
```

[Back to TOC](#table-of-contents)

Parameters
----------

(method-parameters)(https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/method-parameters)

Optional and Named Parameters
-----------------------------

* Default values must be constant at compile time. You can use [default](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/default-value-expressions)(value type) to express default value type
* Change default value is interface change

[Back to TOC](#table-of-contents)

Passing Parameters by Reference to a Method
-------------------------------------------

* There is no difference between out and ref in CLR

```csharp
  static void TestReferenceParameter() {
    int v = 1;
    TestMethod1(out v);
    TestMethod2(ref v);
    TestMethod(v);
  }

  .method private hidebysig static void TestReferenceParameter() cil managed
  {
    // Code size 27
    .maxstack 1
    .locals init(int32 V_0)
    IL_0000: nop
    IL_0001: ldc.i4.1
    IL_0002: stloc.0
    IL_0003: ldloca.s V_0
    IL_0005: call void part2.cp4::TestMethod1(byreference)
    IL_000a: nop
    IL_000b: ldloca.s V_0
    IL_000d: call void part2.cp4::TestMethod2(byreference)
    IL_0012: nop
    IL_0013: ldloc.0
    IL_0014: call void part2.cp4::TestMethod(int32)
    IL_0019: nop
    IL_001a: ret
  } // End of method System.Void part2.cp4::TestReferenceParameter()
```

[Back to TOC](#table-of-contents)

Passing a Variable Number of Arguments to a Method
--------------------------------------------------

* refer [params](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/params)
* It’s legal to pass null or a reference to an array of 0 entries as the last parameter to the method.
* There is no difference between ```csharp (new int[] {3, 4})``` and ```csharp (3,4)``` in CLR
* Try to define several overloaded methods without params to help performance enhancement. Refer [String.Concat](https://docs.microsoft.com/en-us/dotnet/api/system.string.concat?view=netcore-2.2)

```csharp
  static void TestVariableParameters() {
    TestMethodWithVariableParams(new int[] {3, 4});
    TestMethodWithVariableParams(3, 4);
    TestMethodWithVariableParams();
    TestMethodWithVariableParams(null);
  }

  .method private hidebysig static void TestVariableParameters() cil managed
  {
    // Code size 60
    .maxstack 8
    IL_0000: nop
    IL_0001: ldc.i4.2
    IL_0002: newarr System.Int32
    IL_0007: dup
    IL_0008: ldc.i4.0
    IL_0009: ldc.i4.3
    IL_000a: stelem.i4
    IL_000b: dup
    IL_000c: ldc.i4.1
    IL_000d: ldc.i4.4
    IL_000e: stelem.i4
    IL_000f: call void part2.cp4::TestMethodWithVariableParams(int32[])
    IL_0014: nop
    IL_0015: ldc.i4.2
    IL_0016: newarr System.Int32
    IL_001b: dup
    IL_001c: ldc.i4.0
    IL_001d: ldc.i4.3
    IL_001e: stelem.i4
    IL_001f: dup
    IL_0020: ldc.i4.1
    IL_0021: ldc.i4.4
    IL_0022: stelem.i4
    IL_0023: call void part2.cp4::TestMethodWithVariableParams(int32[])
    IL_0028: nop
    IL_0029: call mvar[] [System.Runtime]System.Array::Empty()
    IL_002e: call void part2.cp4::TestMethodWithVariableParams(int32[])
    IL_0033: nop
    IL_0034: ldnull
    IL_0035: call void part2.cp4::TestMethodWithVariableParams(int32[])
    IL_003a: nop
    IL_003b: ret
  } // End of method System.Void part2.cp4::TestVariableParameters()
```

[Back to TOC](#table-of-contents)

Parameter and Return Type Guidelines
-------------------------------------

* When declaring a method’s parameter types, you should specify the weakest type possible, preferring interfaces over base classes
* On the flip side, it is usually best to declare a method’s return type by using the strongest type possible.

[Back to TOC](#table-of-contents)

Properties
----------

Parameterless Properties
------------------------

* Avoid to use automatically implemented properties(AIPs).

```csharp
  internal class PropertyClass {
    public String Name { get; set; }
  }

  .class private auto ansi beforefieldinit part2.PropertyClass extends [System.Runtime]System.Object
  {
    .field private string '<Name>k__BackingField'

    .method public hidebysig specialname instance string get_Name() cil managed
    {
      // Code size 7
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: ldfld string part2.PropertyClass::'<Name>k__BackingField'
      IL_0006: ret
  } // End of method System.String part2.PropertyClass::get_Name()

  .method public hidebysig specialname instance void set_Name(string 'value') cil managed
  {
    // Code size 8
    .maxstack 8
    IL_0000: ldarg.0
    IL_0001: ldarg.1
    IL_0002: stfld string part2.PropertyClass::'<Name>k__BackingField'
    IL_0007: ret
  } // End of method System.Void part2.PropertyClass::set_Name(System.String)

  .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
  {
    // Code size 8
    .maxstack 8
    IL_0000: ldarg.0
    IL_0001: call instance void [System.Runtime]System.Object::.ctor()
    IL_0006: nop
    IL_0007: ret
  } // End of method System.Void part2.PropertyClass::.ctor()
```

[Back to TOC](#table-of-contents)

Object and Collection Initializer
---------------------------------

[Reference](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/object-and-collection-initializers)

* CLR does not know object and collection initializer
* Collection initializers let you specify one or more element initializers when you initialize a collection type that implements IEnumerable and has Add/Indexer with the appropriate signature as an instance method or an extension method.

[Back to TOC](#table-of-contents)

Object Initializer
------------------

```csharp
  static void TestObjectInitializer() {
    Cat cat = new Cat { Age = 10, Name = "Fluffy" };
    Cat sameCat = new Cat("Fluffy") { Age = 10 };
  }

  .method private hidebysig static void TestObjectInitializer() cil managed
  {
    // Code size 49
    .maxstack 3
    .locals init(part2.cp4/Cat V_0, part2.cp4/Cat V_1)
    IL_0000: nop
    IL_0001: newobj instance void part2.cp4/Cat::.ctor()
    IL_0006: dup
    IL_0007: ldc.i4.s 10
    IL_0009: callvirt instance void part2.cp4/Cat::set_Age(int32)
    IL_000e: nop
    IL_000f: dup
    IL_0010: ldstr "Fluffy"
    IL_0015: callvirt instance void part2.cp4/Cat::set_Name(string)
    IL_001a: nop
    IL_001b: stloc.0
    IL_001c: ldstr "Fluffy"
    IL_0021: newobj instance void part2.cp4/Cat::.ctor(string)
    IL_0026: dup
    IL_0027: ldc.i4.s 10
    IL_0029: callvirt instance void part2.cp4/Cat::set_Age(int32)
    IL_002e: nop
    IL_002f: stloc.1
    IL_0030: ret
  } // End of method System.Void part2.cp4::TestObjectInitializer()
```

[Back to TOC](#table-of-contents)

Collection Initializer
----------------------

```csharp
  static void TestCollectionInitializer() {
    List<int> digits = new List<int> {0, 1};
    var moreNumbers = new Dictionary<int, string> {
      {19, "nineteen" }
    };
    var numbers = new Dictionary<int, string> {
      [7] = "seven"
    };
  }

  .method private hidebysig static void TestCollectionInitializer() cil managed
  {
    // Code size 63
    .maxstack 4
    .locals init(genericinstance V_0, genericinstance V_1, genericinstance V_2)
    IL_0000: nop
    IL_0001: newobj instance void genericinstance::.ctor()
    IL_0006: dup
    IL_0007: ldc.i4.0
    IL_0008: callvirt instance void genericinstance::Add(var)
    IL_000d: nop
    IL_000e: dup
    IL_000f: ldc.i4.1
    IL_0010: callvirt instance void genericinstance::Add(var)
    IL_0015: nop
    IL_0016: stloc.0
    IL_0017: newobj instance void genericinstance::.ctor()
    IL_001c: dup
    IL_001d: ldc.i4.s 19
    IL_001f: ldstr "nineteen"
    IL_0024: callvirt instance void genericinstance::Add(var, var)
    IL_0029: nop
    IL_002a: stloc.1
    IL_002b: newobj instance void genericinstance::.ctor()
    IL_0030: dup
    IL_0031: ldc.i4.7
    IL_0032: ldstr "seven"
    IL_0037: callvirt instance void genericinstance::set_Item(var, var)
    IL_003c: nop
    IL_003d: stloc.2
    IL_003e: ret
  } // End of method System.Void part2.cp4::TestCollectionInitializer()
```

[Back to TOC](#table-of-contents)

Anonymous Types
---------------

```csharp
  static void TestAnonymousTypes() {
    var o = new {Name = "lj@sh", Age = 35};
    Console.WriteLine("Name={0}, Age={1}", o.Name, o.Age.ToString());
  }

  .class private auto ansi sealed beforefieldinit <>f__AnonymousType0`2 extends [System.Runtime]System.Object
  {
    .field private initonly var '<Name>i__Field'
    .field private initonly var '<Age>i__Field'

    .method public hidebysig specialname instance var get_Name() cil managed
    {
      // Code size 7
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: ldfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
      IL_0006: ret
  } // End of method <Name>j__TPar <>f__AnonymousType0`2::get_Name()

  .method public hidebysig specialname instance var get_Age() cil managed
  {
    // Code size 7
    .maxstack 8
    IL_0000: ldarg.0
    IL_0001: ldfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_0006: ret
  } // End of method <Age>j__TPar <>f__AnonymousType0`2::get_Age()

  .method public hidebysig specialname rtspecialname instance void .ctor(var Name, var Age) cil managed
  {
    // Code size 21
    .maxstack 8
    IL_0000: ldarg.0
    IL_0001: call instance void [System.Runtime]System.Object::.ctor()
    IL_0006: ldarg.0
    IL_0007: ldarg.1
    IL_0008: stfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
    IL_000d: ldarg.0
    IL_000e: ldarg.2
    IL_000f: stfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_0014: ret
  } // End of method System.Void <>f__AnonymousType0`2::.ctor(<Name>j__TPar,<Age>j__TPar)

  .method public hidebysig virtual instance boolean Equals([System.Runtime]System.Object 'value') cil managed
  {
    // Code size 60
    .maxstack 3
    .locals init(genericinstance V_0)
    IL_0000: ldarg.1
    IL_0001: isinst <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>
    IL_0006: stloc.0
    IL_0007: ldloc.0
    IL_0008: brfalse.s     IL_003a
    IL_000a: call genericinstance genericinstance::get_Default()
    IL_000f: ldarg.0
    IL_0010: ldfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
    IL_0015: ldloc.0
    IL_0016: ldfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
    IL_001b: callvirt instance boolean genericinstance::Equals(var, var)
    IL_0020: brfalse.s     IL_003a
    IL_0022: call genericinstance genericinstance::get_Default()
    IL_0027: ldarg.0
    IL_0028: ldfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_002d: ldloc.0
    IL_002e: ldfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_0033: callvirt instance boolean genericinstance::Equals(var, var)
    IL_0038: br.s     IL_003b
    IL_003a: ldc.i4.0
    IL_003b: ret
  } // End of method System.Boolean <>f__AnonymousType0`2::Equals(System.Object)

  .method public hidebysig virtual instance int32 GetHashCode() cil managed
  {
    // Code size 52
    .maxstack 8
    IL_0000: ldc.i4 -2097246416
    IL_0005: ldc.i4 -1521134295
    IL_000a: mul
    IL_000b: call genericinstance genericinstance::get_Default()
    IL_0010: ldarg.0
    IL_0011: ldfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
    IL_0016: callvirt instance int32 genericinstance::GetHashCode(var)
    IL_001b: add
    IL_001c: ldc.i4 -1521134295
    IL_0021: mul
    IL_0022: call genericinstance genericinstance::get_Default()
    IL_0027: ldarg.0
    IL_0028: ldfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_002d: callvirt instance int32 genericinstance::GetHashCode(var)
    IL_0032: add
    IL_0033: ret
  } // End of method System.Int32 <>f__AnonymousType0`2::GetHashCode()

  .method public hidebysig virtual instance string ToString() cil managed
  {
    // Code size 136
    .maxstack 7
    .locals init(var V_0, var V_1, var V_2, var V_3)
    IL_0000: ldnull
    IL_0001: ldstr "{{ Name = {0}, Age = {1} }}"
    IL_0006: ldc.i4.2
    IL_0007: newarr System.Object
    IL_000c: dup
    IL_000d: ldc.i4.0
    IL_000e: ldarg.0
    IL_000f: ldfld <Name>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Name>i__Field
    IL_0014: stloc.0
    IL_0015: ldloca.s V_0
    IL_0017: ldloca.s V_1
    IL_0019: initobj <Name>j__TPar
    IL_001f: ldloc.1
    IL_0020: box <Name>j__TPar
    IL_0025: brtrue.s     IL_003b
    IL_0027: ldobj <Name>j__TPar
    IL_002c: stloc.1
    IL_002d: ldloca.s V_1
    IL_002f: ldloc.1
    IL_0030: box <Name>j__TPar
    IL_0035: brtrue.s     IL_003b
    IL_0037: pop
    IL_0038: ldnull
    IL_0039: br.s     IL_0046
    IL_003b: constrained. <Name>j__TPar
    IL_0041: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_0046: stelem.ref
    IL_0047: dup
    IL_0048: ldc.i4.1
    IL_0049: ldarg.0
    IL_004a: ldfld <Age>j__TPar <>f__AnonymousType0`2<<Name>j__TPar,<Age>j__TPar>::<Age>i__Field
    IL_004f: stloc.2
    IL_0050: ldloca.s V_2
    IL_0052: ldloca.s V_3
    IL_0054: initobj <Age>j__TPar
    IL_005a: ldloc.3
    IL_005b: box <Age>j__TPar
    IL_0060: brtrue.s     IL_0076
    IL_0062: ldobj <Age>j__TPar
    IL_0067: stloc.3
    IL_0068: ldloca.s V_3
    IL_006a: ldloc.3
    IL_006b: box <Age>j__TPar
    IL_0070: brtrue.s     IL_0076
    IL_0072: pop
    IL_0073: ldnull
    IL_0074: br.s     IL_0081
    IL_0076: constrained. <Age>j__TPar
    IL_007c: callvirt instance string [System.Runtime]System.Object::ToString()
    IL_0081: stelem.ref
    IL_0082: call string string::Format([System.Runtime]System.IFormatProvider, string, [System.Runtime]System.Object[])
    IL_0087: ret
  } // End of method System.String <>f__AnonymousType0`2::ToString()
    .custom instance void [System.Runtime]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = ( 01 00 00 00 )
    .custom instance void [System.Diagnostics.Debug]System.Diagnostics.DebuggerDisplayAttribute::.ctor(string) = ( 01 00 1F 5C 7B 20 4E 61 6D 65 20 3D 20 7B 4E 61 6D 65 7D 2C 20 41 67 65 20 3D 20 7B 41 67 65 7D 20 7D 01 00 54 0E 04 54 79 70 65 10 3C 41 6E 6F 6E 79 6D 6F 75 73 20 54 79 70 65 3E )
  } // End of class <>f__AnonymousType0`2

  .method private hidebysig static void TestAnonymousTypes() cil managed
  {
    // Code size 46
    .maxstack 3
    .locals init(genericinstance V_0, int32 V_1)
    IL_0000: nop
    IL_0001: ldstr "lj@sh"
    IL_0006: ldc.i4.s 35
    IL_0008: newobj instance void genericinstance::.ctor(var, var)
    IL_000d: stloc.0
    IL_000e: ldstr "Name={0}, Age={1}"
    IL_0013: ldloc.0
    IL_0014: callvirt instance var genericinstance::get_Name()
    IL_0019: ldloc.0
    IL_001a: callvirt instance var genericinstance::get_Age()
    IL_001f: stloc.1
    IL_0020: ldloca.s V_1
    IL_0022: call instance string int32::ToString()
    IL_0027: call void [System.Console]System.Console::WriteLine(string, [System.Runtime]System.Object, [System.Runtime]System.Object)
    IL_002c: nop
    IL_002d: ret
  } // End of method System.Void part2.cp4::TestAnonymousTypes()
```

[Back to TOC](#table-of-contents)

Interfaces
----------

Defining an Interface
---------------------

* A method implements a interface is ```public```, ```virtual``` and ```final```
* A virtual method implements a interface can be override by derived class

```csharp
  interface ITest {
    void Test1();
    void Test2();
  }

  internal class Class_ITest : ITest {
    public void Test1() {}
    public virtual void Test2() {}
  }

  .class private interface abstract auto ansi part2.ITest
  {
    .method public hidebysig newslot abstract virtual instance void Test1() cil managed
    {
    } // End of method System.Void part2.ITest::Test1()

    .method public hidebysig newslot abstract virtual instance void Test2() cil managed
    {
    } // End of method System.Void part2.ITest::Test2()
  } // End of class part2.ITest
  
  .class private auto ansi beforefieldinit part2.Class_ITest extends [System.Runtime]System.Object implements part2.ITest
  {

    .method public hidebysig newslot virtual final instance void Test1() cil managed
    {
      // Code size 2
      .maxstack 8
      IL_0000: nop
      IL_0001: ret
    } // End of method System.Void part2.Class_ITest::Test1()

    .method public hidebysig newslot virtual instance void Test2() cil managed
    {
      // Code size 2
      .maxstack 8
      IL_0000: nop
      IL_0001: ret
    } // End of method System.Void part2.Class_ITest::Test2()

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 8
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void [System.Runtime]System.Object::.ctor()
      IL_0006: nop
      IL_0007: ret
    } // End of method System.Void part2.Class_ITest::.ctor()
  } // End of class part2.Class_ITest
```

[Back to TOC](#table-of-contents)

More About Calling Interface Methods
------------------------------------

```csharp
  internal class BaseInterfaceTest : IDisposable {
    // This method is implicitly sealed and cannot be overridden
    public void Dispose() {
      Console.WriteLine("BaseInterfaceTest's Dispose");
    }
  }

  // This class is derived from Base and it re­implements IDisposable
  internal class DerivedInterfaceTest : BaseInterfaceTest, IDisposable {
    // This method cannot override Base's Dispose. 'new' is used to indicate
    // that this method re­implements IDisposable's Dispose method
    new public void Dispose() {
      Console.WriteLine("Derived's Dispose");
      // NOTE: The next line shows how to call a base class's implementation (if desired)
      // BaseInterfaceTest.Dispose();
    }
  }

  static void TestIntefaceMethodReimplementation() {
    /************************* First Example *************************/
    BaseInterfaceTest b = new BaseInterfaceTest();
    // Calls Dispose by using b's type: "BaseInterfaceTest's Dispose"
    b.Dispose();
    // Calls Dispose by using b's object's type: "BaseInterfaceTest's Dispose"
    ((IDisposable)b).Dispose();

    /************************* Second Example ************************/
    DerivedInterfaceTest d = new DerivedInterfaceTest();
    // Calls Dispose by using d's type: "DerivedInterfaceTest's Dispose"
    d.Dispose();
    // Calls Dispose by using d's object's type: "DerivedInterfaceTest's Dispose"
    ((IDisposable)d).Dispose();

    /************************* Third Example *************************/
    b = new DerivedInterfaceTest();
    // Calls Dispose by using b's type: "BaseInterfaceTest's Dispose"
    b.Dispose();
    // Calls Dispose by using b's object's type: "DerivedInterfaceTest's Dispose"
    ((IDisposable)b).Dispose();
  }

  .class private auto ansi beforefieldinit part2.DerivedInterfaceTest extends part2.BaseInterfaceTest implements [System.Runtime]System.IDisposable
  {
    .method public hidebysig newslot virtual final instance void Dispose() cil managed
    {
      // Code size 13
      .maxstack 8
      IL_0000: nop
      IL_0001: ldstr "Derived's Dispose"
      IL_0006: call void [System.Console]System.Console::WriteLine(string)
      IL_000b: nop
      IL_000c: ret
    } // End of method System.Void part2.DerivedInterfaceTest::Dispose()

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 8
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void part2.BaseInterfaceTest::.ctor()
      IL_0006: nop
      IL_0007: ret
    } // End of method System.Void part2.DerivedInterfaceTest::.ctor()
  } // End of class part2.DerivedInterfaceTest
  
  .method private hidebysig static void TestIntefaceMethodReimplementation() cil managed
  {
    // Code size 62
    .maxstack 1
    .locals init(part2.BaseInterfaceTest V_0, part2.DerivedInterfaceTest V_1)
    IL_0000: nop
    IL_0001: newobj instance void part2.BaseInterfaceTest::.ctor()
    IL_0006: stloc.0
    IL_0007: ldloc.0
    IL_0008: callvirt instance void part2.BaseInterfaceTest::Dispose()
    IL_000d: nop
    IL_000e: ldloc.0
    IL_000f: callvirt instance void [System.Runtime]System.IDisposable::Dispose()
    IL_0014: nop
    IL_0015: newobj instance void part2.DerivedInterfaceTest::.ctor()
    IL_001a: stloc.1
    IL_001b: ldloc.1
    IL_001c: callvirt instance void part2.DerivedInterfaceTest::Dispose()
    IL_0021: nop
    IL_0022: ldloc.1
    IL_0023: callvirt instance void [System.Runtime]System.IDisposable::Dispose()
    IL_0028: nop
    IL_0029: newobj instance void part2.DerivedInterfaceTest::.ctor()
    IL_002e: stloc.0
    IL_002f: ldloc.0
    IL_0030: callvirt instance void part2.BaseInterfaceTest::Dispose()
    IL_0035: nop
    IL_0036: ldloc.0
    IL_0037: callvirt instance void [System.Runtime]System.IDisposable::Dispose()
    IL_003c: nop
    IL_003d: ret
  } // End of method System.Void part2.cp4::TestIntefaceMethodReimplementation()
```

[Back to TOC](#table-of-contents)

Explicit Interface Method Implementation
----------------------------------------

the type’s method table contains entries for the following:

* All the virtual instance methods defined by Object, the implicitly inherited base class.
* All the interface methods defined by IDisposable, the inherited interface. In this example, there is only one method, Dispose, because the IDisposable interface defines just one method.
* The new method, Dispose, introduced by SimpleType.

conclusion:

* The method implements a interface is actually a newslot different one from that in interface
* EIMI method can only be called from interface
* We can write following snippet:

```csharp
  internal sealed class SimpleType : IDisposable {
  //public void Dispose() { Console.WriteLine("public Dispose"); } // you can comment out this line
  void IDisposable.Dispose() { Console.WriteLine("IDisposable Dispose"); }
}
```

[Back to TOC](#table-of-contents)
