
using System;
using System.Collections;
using System.Collections.Generic;

namespace clr {
  class partme {
    static void TestForeach() {
      int[] v = new int[] {1, 2, 3};
      foreach (var i in v) {
        Console.WriteLine(i);
      }

      foreach (var i in GetValues()) {
        Console.WriteLine(i);
      }
    }

    static IEnumerable<int> GetValues() {
      yield return 1;
      yield return 2;
    }

    static void TestEquality() {
      int x1 = 5;
      int y1 = 5;
      Console.WriteLine(x1 == y1); // True (by virtue of value equality)

      object x2 = 5;
      object y2 = 5;
      Console.WriteLine (x2 == y2);

      var dt1 = new DateTimeOffset (2010, 1, 1, 1, 1, 1, TimeSpan.FromHours(8));
      var dt2 = new DateTimeOffset (2010, 1, 1, 2, 1, 1, TimeSpan.FromHours(9));
      Console.WriteLine (dt1 == dt2);

      string a = "a";
      string b = "b";
      Console.WriteLine(a == b);

      Console.WriteLine("a" == "abc");
    }
  }
}