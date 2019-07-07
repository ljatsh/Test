
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
  }
}