
using System.Collections.Generic;
using TableFormatter;

namespace Tests {
  public class Row : Dictionary<string, string>, IDataRow {
    public string Value(string column) {
      string value;
      if (TryGetValue(column, out value))
        return value;

      return null;
    }
  }
}