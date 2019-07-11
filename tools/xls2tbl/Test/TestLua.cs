using System;
using NUnit.Framework;
using TableFormatter;

namespace Tests
{
  public class TestLua
  {
      [SetUp]
      public void Setup() {
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
      [Test]
      public void TestTableMapping() {
        Field[] fields = new Field[] {
          new Field("ID", "id", "uint32"),
          new Field("RES_ID", "res_id", "uint32"),
          new Field("BG_COLOR", "bg_color", "string"),
          new Field("C", "condition", "uint32"),
          new Field("C_D", "condition_desc", "string"),
          new Field("TYPE", "type", "uint32")
        };

        Table t = new Table("Face", fields, null);

        Row[] datas = new Row[] {
          new Row{{"ID", "1"}, {"RES_ID", "402"}, {"BG_COLOR", "228,170,57"}, {"C", "0"}, {"C_D", "0"}, {"TYPE", "0"}},
          new Row{{"ID", "2"}, {"RES_ID", "403"}, {"BG_COLOR", "228,170,57"}, {"C", "0"}, {"C_D", "0"}, {"TYPE", "0"}},
          new Row{{"ID", "3"}, {"RES_ID", "407"}, {"BG_COLOR", "228,170,57"}, {"C", "0"}, {"C_D", "0"}, {"TYPE", "0"}}
        };

        NUnit.Framework.TestContext.Progress.WriteLine(Lang.Lua.Mapping(datas, t));
      }
  }
}