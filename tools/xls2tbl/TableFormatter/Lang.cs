using System;
using System.Text;
using System.Collections.Generic;

namespace TableFormatter {
  public class Lang {
    private string name = "";

    static public Lang Lua = new LangLua();

    public Lang(string name) {
      this.name = name;
    }
      
    public virtual string GenerateDocument(Table t) {
      return "";
    }

    public virtual string Mapping(IEnumerable<IDataRow> datas, Table t) {
      return "";
    }

    protected void ThrowNotSupportedDataTypeException(string dataType) {
      throw new NotSupportedException(string.Format("dataType {0} is not supported by language {1}", dataType, name));
    }
  };

  internal class LangLua : Lang {
    public LangLua() : base("lua") {

    }

    public override string GenerateDocument(Table t) {
      StringBuilder sb = new StringBuilder();

      sb.AppendFormat("--- @field [parent=#Table] #{0}, {0}\r\n\r\n", t.Name);

      sb.AppendFormat("--- @function [parent=#{0}] get\r\n", t.Name);
      foreach (var field in t.KeyFields) {
        sb.AppendFormat("-- @param #{0} {1}\r\n", GetDocumentByDataType(field.DataType), field.Name);
      }
      sb.AppendFormat("-- @return #{0}_GetReturn\r\n\r\n", t.Name);

      sb.AppendFormat("--- @type {0}_GetReturn\r\n", t.Name);
      foreach (var field in t.Fields) {
        sb.AppendFormat("-- @field #{0} {1}\r\n", GetDocumentByDataType(field.DataType), field.Name);
      }

      return sb.ToString();
    }

    private string GetDocumentByDataType(string dataType) {
      if (String.Compare(dataType, "int32", false) == 0) {
        return "number";
      }

      if (String.Compare(dataType, "uint32", false) == 0) {
        return "number";
      }

      if (String.Compare(dataType, "string", false) == 0) {
        return "string";
      }

      ThrowNotSupportedDataTypeException(dataType);
      return null;
    }

      // --- @field [parent=#Table] #Face Face

      // --- @function [parent=#Face] get
      // -- @param #number id 
      // -- @return #Face_GetReturn

      // --- @type Face_GetReturn
      // -- @field #number id
      // -- @field #number res_id
      // -- @field #string bg_color
      // -- @field #number condition
      // -- @field #string condition_desc
      // -- @field #number type
      // Face = {
      // switch = {id=1,res_id=2,bg_color=3,condition=4,condition_desc=5,type=6},
      // [1] = {1, 402, "228,170,57", 0, "0", 0},
      // [2] = {2, 403, "228,170,57", 0, "0", 0},
      // [3] = {3, 407, "228,170,57", 0, "0", 0},
      // }
    public override string Mapping(IEnumerable<IDataRow> datas, Table t) {
      StringBuilder sb = new StringBuilder();
      sb.Append(GenerateDocument(t));

      // Face = {
      sb.AppendFormat("{0} = {{\r\n", t.Name);

      // switch = {id=1,res_id=2,bg_color=3,condition=4,condition_desc=5,type=6},
      sb.Append("switch = {");
      int index=1;
      foreach (var field in t.Fields) {
        if (index < t.FieldCount)
          sb.AppendFormat("{0}={1},", field.Name, index++);
        else
          sb.AppendFormat("{0}={1}}},\r\n", field.Name, index++);
      }

      // [1] = {1, 402, "228,170,57", 0, "0", 0},
      // [2] = {2, 403, "228,170,57", 0, "0", 0},
      // [3] = {3, 407, "228,170,57", 0, "0", 0},

      List<string> keys = new List<string>();
      List<string> values = new List<string>();
      foreach (var row in datas) {
        keys.Clear();
        foreach(var field in t.KeyFields) {
          keys.Add(TableFormatter.Mapping.MappingString.Map(row.Value(field.SourceName)));
        }

        values.Clear();
        foreach(var field in t.Fields) {
          values.Add(GetMapper(field.DataType).Map(row.Value(field.SourceName)));
        }

        sb.AppendFormat("[{0}] = {{{1}}},\r\n", String.Join("_", keys), String.Join(", ", values));
      }

      sb.Append("}\r\n");

      return sb.ToString();
    }

    private Mapping GetMapper(string dataType) {
      if (String.Compare(dataType, "int32", false) == 0) {
        return TableFormatter.Mapping.MappingInt32;
      }

      if (String.Compare(dataType, "uint32", false) == 0) {
        return TableFormatter.Mapping.MappingUInt32;
      }

      if (String.Compare(dataType, "string", false) == 0) {
        return TableFormatter.Mapping.MappingString;
      }

      ThrowNotSupportedDataTypeException(dataType);
      return null;
    }
  }
}