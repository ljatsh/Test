using System;
using System.Collections.Generic;

namespace TableFormatter {
  public class Field {
    private string sourceName;
    private string name;
    private string dataType;

    public string SourceName {
      get { return sourceName; }
    }

    public string Name {
      get { return name ; }
    }

    public string DataType {
      get { return dataType; }
    }

    public Field(string sourceName, string name, string dataType) {
      this.sourceName = sourceName;
      this.name = name;
      this.dataType = dataType;
    }
  }
}
