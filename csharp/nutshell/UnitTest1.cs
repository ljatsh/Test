using NUnit.Framework;

namespace Tests
{
  [TestFixture]
  public class Tests
  {
    [SetUp]
    public void Setup()
    {
    }

    [Test]
    public void Test1()
    {
      Assert.That(0, Is.Zero);
      Assert.That("hello", Is.EqualTo("hello"));
    }
  }
}