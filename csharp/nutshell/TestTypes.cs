using NUnit.Framework;
using System;

namespace Tests
{
  // const vs readonly
  // 1. A constant is a static field whose value cannot change. A constant is evaluated statically at compile time and the compiler literally substitues its value whenever used(rather like a macro in C++). A constant can be any of the built-in numeric types, bool, char, string, or an enum type. Struct cannot be constant.
  class Constant  {
    public const int AGE = 18;
    public const float SALARY = 1200.3f;
    public const bool MAN = false;
    public const string NAME = "lj@sh";

    //pubic const DateTime BIRTHDAY = new DateTime(); // illegal statement
  }

  [TestFixture]
  public class TestTypes
  {
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void TestConst()
    {
      Constant v = new Constant();
      Assert.That(Constant.AGE, Is.EqualTo(18));
      // Assert.That(v.AGE, Is.EqualTo(18)); // illegal statement
      Assert.That(Constant.SALARY, Is.EqualTo(1200.3f));
      Assert.That(Constant.MAN, Is.False);
      Assert.That(Constant.NAME, Is.EqualTo("lj@sh"));
    }
  }
}