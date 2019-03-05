using System;

namespace clr {
  internal delegate void Feedback(Int32 value);

  internal class TestWrapper {
    public void FeedbackImpl(Int32 value) { }
  }

  public class part3 {
    public static void TestDelegate() {
      Feedback v1 = new Feedback(System.Console.Write);
      v1(1);
      Feedback v2 = new Feedback(new TestWrapper().FeedbackImpl);
      v2(1);
    }

    public static void TestDelegateChain() {
      Feedback v1 = new Feedback(System.Console.Write);
      Feedback v2 = new Feedback(new TestWrapper().FeedbackImpl);

      Feedback v3 = v1 + v2;
      v3(1);
      Feedback v4 = (Feedback)Delegate.Combine(v1, v2);
      v4(1);
    }
  } // class part3
} // namespace clr
