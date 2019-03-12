using NUnit.Framework;
using Moq;
using System;

namespace Test {
  // 1. Object.ReferenceEquals is designed to perform identity comparision

  internal class EqualityTestClass {
    public int Age { get; set; }

    public override bool Equals(object obj) {
      return base.Equals(obj);
    }

    public override int GetHashCode() {
      return 0;
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
      var o1 = new EqualityTestClass();
      var o2 = new EqualityTestClass();
      Assert.That(o1.Equals(o2), Is.False);
      Assert.That(o1.Equals(o1), Is.True);
    }

    // Object.Equals(left, right) is a helper method to invoke left.Equals
    [Test]
    public void TestObjectStaticEquals() {
      var mock = new Mock<EqualityTestClass>();
      // TODO
    }
  }
}