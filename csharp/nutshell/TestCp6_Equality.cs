using NUnit.Framework;
using Moq;
using System;

namespace Test {
  // 1. Object.ReferenceEquals is designed to perform identity comparision
  // 2. Object.Equals(a, b) is good equality checker to avoid null check
  // 3. Always override Equals if the class/value has object equality meaning
  //    If your implementation of Equals fails to adhere to all of the following rules, your application will behave in strange and unpredictable ways
  //    * Equals must be reflexive; that is, x.Equals(x) must return true.
  //    * Equals must be symmetric; that is, x.Equals(y) must return the same value as y.Equals(x).
  //    * Equals must be transitive; that is, if x.Equals(y) returns true and y.Equals(z) returns true, then x.Equals(z) must also return true.
  //    * Equals must be consistent. Provided that there are no changes in the two values being compared, Equals should consistently return true or false
  // 4. Always to implement IEquatable<T> to enhance performance. see https://docs.microsoft.com/en-us/dotnet/api/system.iequatable-1.equals?view=netcore-2.2 and System.Int32

  public class EqualityTestClass : IEquatable<EqualityTestClass> {
    public int Age { get; set; }

    public override bool Equals(object obj) {
      if (obj == null || !this.GetType().Equals(obj.GetType()))
        return false;

      EqualityTestClass o = (EqualityTestClass)obj;

      return Equals(o);
    }

    public bool Equals(EqualityTestClass obj) {
      return Age == obj.Age;
    }

    public override int GetHashCode() {
      return Age;
    }
  }

  internal struct EqualityTestStruct {
    public DateTime               Birthday;
    public EqualityTestClass      OtherInfo;

    public EqualityTestStruct(DateTime birthday, int age) {
      Birthday = birthday;
      OtherInfo = new EqualityTestClass {Age = age};
    }
  }

  [TestFixture]
  public class TestCp6_Equality {
    // Object.ReferenceEquals is designed to compare object identity
    [Test]
    public void TestReferenceEquals() {
      Assert.That(Object.ReferenceEquals(null, null), Is.True);
      var suffix = "_";
      var o1 = "TestString" + suffix;
      var o2 = "TestString" + suffix;
      var o3 = o1;
      Assert.That(Object.ReferenceEquals(null, o1), Is.False);
      Assert.That(Object.ReferenceEquals(o1, o2), Is.False);
      Assert.That(Object.ReferenceEquals(o1, o3), Is.True);

      // Object.ReferenceEquals(valueType1, valueType2) always returns false
      int age = 34;
      Assert.That(Object.ReferenceEquals(age, age), Is.False);

      // When comparing strings, the interned string is compared if the string is interned.
      var s1 = "TestString";
      var s2 = "TestString";
      Assert.That(String.IsInterned(s1), Is.Not.Null);
      Assert.That(String.IsInterned(s2), Is.Not.Null);
      Assert.That(Object.ReferenceEquals(s1, s2), Is.True);
    }

    // Object.Equal is designed to perform object comparision.
    // However, its default implementation is identity comparision.
    [Test]
    public void TestObjectEqual() {
      var o1 = new EqualityTestClass {Age = 1};
      var o2 = new EqualityTestClass {Age = 2};
      var o3 = new EqualityTestClass {Age = 2};
      Assert.That(o1.Equals(o2), Is.False);
      Assert.That(o2.Equals(o3), Is.True);
    }

    // ValueType.Equals is inefficient if it contains reference type
    [Test]
    public void TestValueEquals() {
      EqualityTestStruct s1 = new EqualityTestStruct(new DateTime(2019, 3, 12), 10);
      EqualityTestStruct s2 = new EqualityTestStruct(new DateTime(2019, 3, 12), 11);

      Assert.That(s1.Equals(s2), Is.False);

      var mock = new Mock<EqualityTestClass>();
      mock.Setup(m => m.Equals((Object)s2.OtherInfo)).Returns(true);
      s1.OtherInfo = mock.Object;

      Assert.That(s1.Equals(s2), Is.True);
      mock.Verify(m => m.Equals((Object)s2.OtherInfo), Times.Once);
    }

    // Object.Equals(left, right) is a helper method to invoke left.Equals
    [Test]
    public void TestObjectStaticEquals() {
      var mock = new Mock<EqualityTestClass>();
      Object o = new EqualityTestClass();

      mock.Setup(m => m.Equals(o)).Returns(false);

      Assert.That(Object.Equals(null, mock.Object), Is.False);
      mock.Verify(m => m.Equals(o), Times.Never);

      Assert.That(Object.Equals(mock.Object, o), Is.False);
      mock.Verify(m => m.Equals(o), Times.Once);
    }

    // IL
    // .method public hidebysig instance void TestIEquatable() cil managed
    // {
    //   // Code size 75
    //   .maxstack 3
    //   .locals init(Test.EqualityTestClass V_0, [System.Runtime]System.Object V_1, Test.EqualityTestClass V_2)
    //   IL_0000: nop
    //   IL_0001: newobj instance void Test.EqualityTestClass::.ctor()
    //   IL_0006: dup
    //   IL_0007: ldc.i4.s 10
    //   IL_0009: callvirt instance void Test.EqualityTestClass::set_Age(int32)
    //   IL_000e: nop
    //   IL_000f: stloc.0
    //   IL_0010: newobj instance void Test.EqualityTestClass::.ctor()
    //   IL_0015: dup
    //   IL_0016: ldc.i4.s 10
    //   IL_0018: callvirt instance void Test.EqualityTestClass::set_Age(int32)
    //   IL_001d: nop
    //   IL_001e: stloc.1
    //   IL_001f: ldloc.1
    //   IL_0020: castclass Test.EqualityTestClass
    //   IL_0025: stloc.2
    //   IL_0026: ldloc.0
    //   IL_0027: ldloc.1
    //   IL_0028: callvirt instance boolean [System.Runtime]System.Object::Equals([System.Runtime]System.Object)
    //   IL_002d: call [nunit.framework]NUnit.Framework.Constraints.TrueConstraint [nunit.framework]NUnit.Framework.Is::get_True()
    //   IL_0032: call void [nunit.framework]NUnit.Framework.Assert::That(mvar, [nunit.framework]NUnit.Framework.Constraints.IResolveConstraint)
    //   IL_0037: nop
    //   IL_0038: ldloc.0
    //   IL_0039: ldloc.2
    //   IL_003a: callvirt instance boolean Test.EqualityTestClass::Equals(Test.EqualityTestClass)
    //   IL_003f: call [nunit.framework]NUnit.Framework.Constraints.TrueConstraint [nunit.framework]NUnit.Framework.Is::get_True()
    //   IL_0044: call void [nunit.framework]NUnit.Framework.Assert::That(mvar, [nunit.framework]NUnit.Framework.Constraints.IResolveConstraint)
    //   IL_0049: nop
    //   IL_004a: ret
    // } // End of method System.Void Test.TestCp6_Equality::TestIEquatable()
    [Test]
    [Ignore("This is just used to demostrate static binding")]
    public void TestIEquatable() {
      var o1 = new EqualityTestClass {Age = 10};
      Object o2 = new EqualityTestClass {Age = 10};
      var o3 = (EqualityTestClass)o2;

      Assert.That(o1.Equals(o2), Is.True);
      Assert.That(o1.Equals(o3), Is.True);
    }
  }
}