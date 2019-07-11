using System;
using System.Collections.Generic;

// TODO. How to implement IEnumerable<T>

namespace TableFormatter {
  public class Table {
    private string name;

    private List<Field> fields;

    private List<Field> keyFields;

    public string Name {
      get { return name; }
      set { name = value; }
    }

    public IEnumerable<Field> Fields {
      get { return fields; }
    }

    public IEnumerable<Field> KeyFields {
      get { return keyFields; }
    }

    public int FieldCount {
      get { return fields.Count; }
    }

    public Table(string name, IEnumerable<Field> fields, IEnumerable<Field> keyFields) {
      this.name = name;
      this.fields = new List<Field>(fields);
      if (keyFields == null) {
        this.keyFields = new List<Field>{this.fields[0]};
      } else {
        this.keyFields = new List<Field>(keyFields);
      }
    }
  }
}
