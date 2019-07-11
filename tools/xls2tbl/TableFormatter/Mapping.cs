using System;

namespace TableFormatter {
  public class Mapping {
    static Mapping MappingInt32 = new Int32Mapping();
    static Mapping MappingUInt32 = new UInt32Mapping();
    static Mapping MappingFloat = new NumericMapping(Single.MinValue, Single.MaxValue);
    static Mapping MappingString = new StringMapping();

    public virtual string Map(string input) {
      return input;
    }
  }

  internal class NumericMapping : Mapping {
    private float minValue;
    private float maxValue;

    public NumericMapping(float minValue, float maxValue) {
      this.minValue = minValue;
      this.maxValue = maxValue;
    }

    protected float read(string input) {
      if (input == null) {
        return 0f;
      }

      float result = Convert.ToSingle(input);

      if (result <= minValue || result >= maxValue) {
        throw new OverflowException(string.Format("Number {0} is out of range [{1}-{2}]", result, minValue, maxValue));
      }

      return result;
    }

    protected virtual string write(float input) {
      return Convert.ToString(input);
    }

    public override string Map(string input) {
      float result = read(input);
      return write(result);
    }
  }

  internal class Int32Mapping : NumericMapping {
    public Int32Mapping() : base(Int32.MinValue, Int32.MaxValue) {

    }

    protected override string write(float input) {
      return Convert.ToString(Convert.ToInt32(input));
    }
  }

  internal class UInt32Mapping : NumericMapping {
    public UInt32Mapping() : base(UInt32.MinValue, UInt32.MaxValue) {

    }

    protected override string write(float input) {
      return Convert.ToString(Convert.ToInt32(input));
    }
  }

  public class StringMapping : Mapping {
    public override string Map(string input) {
      if (input == null) {
        return "";
      }

      return string.Format("\"{0}\"", input.Replace("\"", "\\\""));
    }
  }
}
