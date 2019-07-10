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
      public void TestTableDocument() {
        Field[] fields = new Field[] {
          new FiledUInt32("id"),
          new FiledUInt32("res_id"),
          new FiledString("bg_color"),
          new FiledUInt32("condition"),
          new FiledString("condition_desc"),
          new FiledUInt32("type")
        };
        Table t = new Table("Face", fields);

        Assert.That(true, Is.False);
      }
  }
}