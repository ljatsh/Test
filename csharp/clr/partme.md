Table of Contents
=================

* [foreach](#foreach)

foreach
-------

[foreach](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/foreach-in) can be used to traverse a collection implemetns IEnumerable. The foreach statement is not limited to those types. System.Span<T> is an example.
foreach over an array is optimized.
foreach statement over an collection implements IDispose also handles resource cleanup.

```csharp
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

  .method private hidebysig static void TestForeach() cil managed
  {
    // Code size 108
    .maxstack 3
    .locals init(int32[] V_0, int32[] V_1, int32 V_2, int32 V_3, genericinstance V_4, int32 V_5)
    IL_0000: nop
    IL_0001: ldc.i4.3
    IL_0002: newarr System.Int32
    IL_0007: dup
    IL_0008: ldtoken <PrivateImplementationDetails>/__StaticArrayInitTypeSize=12 <PrivateImplementationDetails>::E429CCA3F703A39CC5954A6572FEC9086135B34E
    IL_000d: call void [netstandard]System.Runtime.CompilerServices.RuntimeHelpers::InitializeArray([netstandard]System.Array, [netstandard]System.RuntimeFieldHandle)
    IL_0012: stloc.0
    IL_0013: nop
    IL_0014: ldloc.0
    IL_0015: stloc.1
    IL_0016: ldc.i4.0
    IL_0017: stloc.2
    IL_0018: br.s     IL_002b
    IL_001a: ldloc.1
    IL_001b: ldloc.2
    IL_001c: ldelem.i4
    IL_001d: stloc.3
    IL_001e: nop
    IL_001f: ldloc.3
    IL_0020: call void [netstandard]System.Console::WriteLine(int32)
    IL_0025: nop
    IL_0026: nop
    IL_0027: ldloc.2
    IL_0028: ldc.i4.1
    IL_0029: add
    IL_002a: stloc.2
    IL_002b: ldloc.2
    IL_002c: ldloc.1
    IL_002d: ldlen
    IL_002e: conv.i4
    IL_002f: blt.s     IL_001a
    IL_0031: nop
    IL_0032: call genericinstance clr.partme::GetValues()
    IL_0037: callvirt instance genericinstance genericinstance::GetEnumerator()
    IL_003c: stloc.s V_4
    IL_003e: br.s     IL_0053
    IL_0040: ldloc.s V_4
    IL_0042: callvirt instance var genericinstance::get_Current()
    IL_0047: stloc.s V_5
    IL_0049: nop
    IL_004a: ldloc.s V_5
    IL_004c: call void [netstandard]System.Console::WriteLine(int32)
    IL_0051: nop
    IL_0052: nop
    IL_0053: ldloc.s V_4
    IL_0055: callvirt instance boolean [netstandard]System.Collections.IEnumerator::MoveNext()
    IL_005a: brtrue.s     IL_0040
    IL_005c: leave.s     IL_006b
    IL_005e: ldloc.s V_4
    IL_0060: brfalse.s     IL_006a
    IL_0062: ldloc.s V_4
    IL_0064: callvirt instance void [netstandard]System.IDisposable::Dispose()
    IL_0069: nop
    IL_006a: endfinally
    IL_006b: ret
  } // End of method System.Void clr.partme::TestForeach()
```