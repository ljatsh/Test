using NUnit.Framework;
using System;
using System.Text;

namespace Test {
  // Refer: https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/anonymous-functions
  // Refer: https://en.wikipedia.org/wiki/Closure_(computer_programming)
  // 1. Prefer to use lambda instead of anoymous method
  // 2. Closure contains both logic and the cpatured state information
  // 3. Avoid to have more than 1 closures to capture the same free variable, unless you know what are you doing.

  [TestFixture]
  public class TestCp4_AnonyousMethod {
    // Anonymous Method is introducted in C# 2.0. Prefer to use lambda instead.
    // A unique feature of anonymous methods is that you can omit the parameter declaration entirely—even if the delegate expects them.
    // All parameter type should be explicitly specified.
    [Test]
    public void TestAnonymousFunction() {
      Func<int> v1 = delegate { return 1; };
      Func<int, int> v2 = delegate(int v) { return v * 2; };

      Assert.That(v1(), Is.EqualTo(1));
      Assert.That(v2(2), Is.EqualTo(4));
    }

    // Anonymous Function + Bound Variables ==> Closure
    // The life time of the bound variables were changed.
    // Cannot use ref, out, in parameters in an anonymous method, lambda expresxsion, query expression, or local function(https://stackoverflow.com/questions/1365689/cannot-use-ref-or-out-parameter-in-lambda-expressions)
    [Test]
    public void TestClosure() {
      StringBuilder sb = new StringBuilder("hello");
      int age = 30;

      Action v = delegate() {
        sb.Append(",sir.");
        age += 10;
      };
      v();
      Assert.That(sb.ToString(), Is.EqualTo("hello,sir."));
      Assert.That(age, Is.EqualTo(40));
    }

    [Test]
    // (input parameters ... ) expression
    // It can be assigned to Action or Func
    // Parameter type can be explicitly assigned
    public void TestLambdaExpression() {
      int v = 1;

      Action f1 = () => v += 1;
      f1();
      Assert.That(v, Is.EqualTo(2));

      Func<int, int> f2 = x => x += 2;
      Assert.That(f2(1), Is.EqualTo(3));

      Func<int, int> f3 = (int x) => x+= 3;
      Assert.That(f3(1), Is.EqualTo(4));
    }

    [Test]
    // (input parameters ...) { statement; }
    public void TestLambdaStatement() {
      int v = 1;
      Action f1 = () => {
        v += 1;
        // ...
        v = 10;
      };
      f1();
      Assert.That(v, Is.EqualTo(10));
    }
  }
}