using System;
using System.Collections;
using System.Collections.Generic;

namespace part2 {

// The main advantage of value types is that they’re not allocated as objects in the managed heap.
struct SomeValue : IComparable {
  public int x;

  public int CompareTo(object obj) {
    return 0;
  }

  public override string ToString() {
    return base.ToString();
  }
}

class ClassMethodCalling {
  public int Method1(int i) { return i + 1; }

  public virtual int Method2(int i) { return i + 2; }

  public static int Method3(int i) { return i + 3; }

  public override String ToString() {
    return base.ToString();
  }
}

struct ValueMethodCalling {
  public int Method1(int i) { return i + 1; }

  public static int Method3(int i) { return i + 3; }

  public override String ToString() {
    return base.ToString();
  }
}

class SomeClassWithConstant {
  public const int AGE = 10;
  public readonly int MAX_AGE = 100;
}

struct ValueMethod {
  private float field1;
  private int field2;
}

class ClassMethod {
  private float field1 = 1.0f;
  private int field2;
  private string field3;

  private ValueMethod field4;

  public ClassMethod() {
    field2 = 1;
    field3 = "lj@sh";
  }

  public ClassMethod(int field2): this() {
    this.field2 = field2;
  }
}

internal class PropertyClass {
  public String Name { get; set; }
}

static class ExtensionClass {
  public static String Dump(this IEnumerable data) { return ""; }
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

  // Point is a value type.
  internal struct Point{
    private Int32 m_x, m_y;
    public Point(Int32 x, Int32 y) {
      m_x = x;
      m_y = y;
    }
    public void Change(Int32 x, Int32 y) {
      m_x = x; m_y = y;
    }
    public override String ToString() {
      return String.Format("({0}, {1})", m_x.ToString(), m_y.ToString());
    }
  }

  static void TestPreferImmutableValueType() {
    Point p = new Point(1, 1);

    Object o = p;
    // a new unboxed temporary variable is created by IL
    ((Point) o).Change(3, 3);
  }
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

  static void TestExtensionMethod() {
    String o = null;
    o.Dump();
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

  static void TestMethod1(out int p) {
    p = 10;
  }
  static void TestMethod2(ref int p) {
  }
  static void TestMethod(int p) {
  }

  static void TestReferenceParameter() {
    int v = 1;
    TestMethod1(out v);
    TestMethod2(ref v);
    TestMethod(v);
  }

  static void TestMethodWithVariableParams(params int[] p) {

  }

  static void TestVariableParameters() {
    TestMethodWithVariableParams(new int[] {3, 4});
    TestMethodWithVariableParams(3, 4);
    TestMethodWithVariableParams();
    TestMethodWithVariableParams(null);
  }

  static void TestProperty() {
    var o = new PropertyClass();
    o.Name = "";
    Console.WriteLine(o.Name);
  }

  internal class Cat {
      // Auto-implemented properties.
      public int Age { get; set; }
      public string Name { get; set; }

      public Cat() {
      }

      public Cat(string name) {
          this.Name = name;
      }
  }

  static void TestObjectInitializer() {
    Cat cat = new Cat { Age = 10, Name = "Fluffy" };
    Cat sameCat = new Cat("Fluffy") { Age = 10 };
  }

  static void TestCollectionInitializer() {
    List<int> digits = new List<int> {0, 1};
    var moreNumbers = new Dictionary<int, string> {
      {19, "nineteen" }
    };
    var numbers = new Dictionary<int, string> {
      [7] = "seven"
    };
  }

  static void TestAnonymousTypes() {
    var o = new {Name = "lj@sh", Age = 35};
    Console.WriteLine("Name={0}, Age={1}", o.Name, o.Age.ToString());
  }
} // class cp4

} // namespace part2