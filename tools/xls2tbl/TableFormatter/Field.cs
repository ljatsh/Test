using System;

namespace TableFormatter {
  public class Field {
    private string name;

    public string Name {
      get { return name ; }
      set { name = value ; }
    }

    public Field(string name) {
      this.name = name;
    }

    // throws InvalidCastException
    public virtual string ConvertToLua(string input) {
      return input;
    }
  }

  public class FiledInt32 : Field {
    public FiledInt32(string name) : base(name) {
    }

    public override string ConvertToLua(string input) {
      try {
        int result = Int32.Parse(input);
        return string.Format("{0}", result);
      } catch (Exception e) {
        throw new InvalidCastException(e.Message);
      }
    }
  }

  public class FiledUInt32 : Field {
    public FiledUInt32(string name) : base(name) {
    }

    public override string ConvertToLua(string input) {
      try {
        uint result = UInt32.Parse(input);
        return string.Format("{0}", result);
      } catch (Exception e) {
        throw new InvalidCastException(e.Message);
      }
    }
  }

  public class FiledString : Field {
    public FiledString(string name) : base(name) {

    }
  }
}
