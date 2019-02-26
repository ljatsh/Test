using NUnit.Framework;
using System;
using System.Collections.Generic;

namespace Tests {
  [TestFixture]
  public class TestNUnitConstraint {
    [SetUp]
    public void Setup() {

    }

    [Test]
    public void TestComparision() {
      // GreaterThan
      // https://github.com/nunit/docs/wiki/GreaterThanConstraint

      Assert.That(1, Is.Positive);
      Assert.That(1.5f, Is.Positive);

      Assert.That("bcd", Is.GreaterThan("abc"));

      // TODO Modifier Check and Method Injection

      // GreaterThanOrEqual
      // https://github.com/nunit/docs/wiki/GreaterThanOrEqualConstraint

      Assert.That(1, Is.GreaterThanOrEqualTo(1));
      Assert.That(5, Is.AtLeast(4));

      // TODO Modifier Check

      // LessThan
      // https://github.com/nunit/docs/wiki/LessThanConstraint
      Assert.That(1, Is.LessThan(2));
      Assert.That(-1, Is.Negative);

      // TODO Modifier checked

      // LessThanOrEqual
      // https://github.com/nunit/docs/wiki/LessThanOrEqualConstraint
      Assert.That(2, Is.LessThanOrEqualTo(2.0f));
      Assert.That(2, Is.AtMost(2.0f));

      // TODO Modifier check

      // RangeConstraint
      // https://github.com/nunit/docs/wiki/RangeConstraint
      // Returns a constraint that tests whether the actual value falls inclusively within a specified range.
      Assert.That(42, Is.InRange(42, 43));

      int[] array = new int[] { 1, 2, 3 };
      Assert.That(array, Is.All.InRange(1, 3));

      // TODO Modifier Check
    }

    [Test]
    public void TestCompound() {
      // AndConstraint
      // combines two other constraints and succeeds only if they both succeed.
      // https://github.com/nunit/docs/wiki/AndConstraint
      Assert.That(2.0f, Is.LessThan(3.0f).And.GreaterThan(1.0f));

      // TODO Evaluation Order and Precedence

      // NotConstraint
      // reverses the effect of another constraint. If the base constraint fails, NotConstraint succeeds. If the base constraint succeeds, NotConstraint fails.
      // https://github.com/nunit/docs/wiki/NotConstraint
      Assert.That(4, Is.Not.EqualTo(5));

      // OrConstraint
      // combines two other constraints and succeeds if either of them succeeds.
      // https://github.com/nunit/docs/wiki/OrConstraint
      Assert.That(2.0f, Is.LessThan(1.0f).Or.GreaterThan(-1.0f));

      // TODO Evaluation Order and precedence
    }

    [Test]
    public void TestConditional() {
      // EmptyConstraint
      // tests that an object is an empty string, directory or collection
      // https://github.com/nunit/docs/wiki/EmptyConstraint

      String v = null;
      Assert.That(v, Is.Not.Empty);
      Assert.That("", Is.Empty);
      Assert.That(new int[]{}, Is.Empty);
      Assert.That(new Dictionary<int, int>(), Is.Empty);

      // FalseConstraint and TrueContraint
      // Expected type is boolean
      Assert.That(true, Is.True);
      Assert.That(false, Is.False);
      //Assert.That(0, Is.True);
      //Assert.That("1", Is.True);

      // NullConstraint
      // test that a value is null
      Assert.That(v, Is.Null);
    
      // NanConstraint
      // test that a value is floating-point NaN
      // TODO
    }
  }
}