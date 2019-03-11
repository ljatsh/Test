using NUnit.Framework;
using Moq;
using System;

namespace Tests {
  public interface IFoo {
    // Property
    string Name { get; set ;}

    // overloaded methods
    bool DoSomething(string value);
    bool DoSomething(int number, string value);
  }

  [TestFixture]
  public class TestMoq {
    [Test]
    public void TestMockInterface() {
      var mock = new Mock<IFoo>();
      mock.Setup(foo => foo.DoSomething("ping")).Returns(true);

      var obj = mock.Object;
      obj.DoSomething("ping");

      mock.Verify(foo => foo.DoSomething("ping"));
    }
  }
}
