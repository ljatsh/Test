using NUnit.Framework;
using System;

namespace Tests {
  [TestFixture]
  public class TestNUnit {
    [SetUp]
    public void Setup() {

    }

    [Test]
    public void TestComparisionConstraint() {
      // https://github.com/nunit/docs/wiki/GreaterThanConstraint

      Assert.That(1, Is.Positive);
      Assert.That(1.5f, Is.Positive);

      Assert.That("bcd", Is.GreaterThan("abc"));
    }
  }
}