using System;
using System.Collections.Generic;

// TODO. How to implement IEnumerable<T>

namespace TableFormatter {
  public class Table {
    private string name;

    private List<Field> fields;

    public string Name {
      get { return name; }
      set { name = value; }
    }

    public Table(string name, IEnumerable<Field> fields) {
      this.name = name;
      fields = new List<Field>(fields);
    }

    public string DocumentToLua() {
      return null;
    }

    public string ConvertDataToLua(IEnumerable<string> rowData) {
      return null;
    }

    public string ConvertDatasToLua(IEnumerable<IEnumerable<string>> datas) {
      return null;
    }
  }
}
