Table of Contents
=================

* [dev environment](#dev_env)
* [ildsam](#ildsam)
* [items](#items)

dev_env
-------

* [mono](https://www.mono-project.com/)
* [.net core](https://docs.microsoft.com/en-us/dotnet/core/)
* [.net core API](https://docs.microsoft.com/en-us/dotnet/api/?view=netcore-2.2)
* [nuget](https://docs.microsoft.com/en-us/nuget)
* [nunit](https://github.com/nunit/docs/wiki/NUnit-Documentation)
* [nunit-assert-classic-model](https://github.com/nunit/docs/wiki/Classic-Model)
* [nunit-assert-constraint-model](https://github.com/nunit/docs/wiki/Constraint-Model)
* [nunit-constraint](https://github.com/nunit/docs/wiki/Constraints)

ildsam
-------

* [install](https://www.nuget.org/packages/dotnet-ildasm/)
* [ildsam reference](https://docs.microsoft.com/en-us/dotnet/framework/tools/ildasm-exe-il-disassembler)

items
-----

1. const vs readonly
* const
  * indicates static field, can only be used to primitive types.

  ```csharp
  class Constant  {
    public const int AGE = 18;
    public const float SALARY = 1200.3f;
    public const bool MAN = false;
    public const string NAME = "lj@sh";

    //pubic const DateTime BIRTHDAY = new DateTime(); // illegal statement
  }

  .class private auto ansi beforefieldinit Tests.Constant extends [System.Runtime]System.Object
  {
    .field public static int32 AGE
    .field public static single SALARY
    .field public static boolean MAN
    .field public static string NAME

    .method public hidebysig specialname rtspecialname instance void .ctor() cil managed
    {
      // Code size 8
      .maxstack 8
      IL_0000: ldarg.0
      IL_0001: call instance void [System.Runtime]System.Object::.ctor()
      IL_0006: nop
      IL_0007: ret
  } // End of method System.Void Tests.Constant::.ctor()
  } // End of class Tests.Constant

  Constant v = new Constant();
  Assert.That(Constant.AGE, Is.EqualTo(18));
  // Assert.That(v.AGE, Is.EqualTo(18)); // illegal statement
  
  IL_0006: stloc.0
  IL_0007: ldc.i4.s 18
  IL_0009: ldc.i4.s 18
  IL_000b: box System.Int32
  IL_0010: call [nunit.framework]NUnit.Framework.Constraints.EqualConstraint [nunit.framework]NUnit.Framework.Is::EqualTo([System.Runtime]System.Object)
  IL_0015: call void [nunit.framework]NUnit.Framework.Assert::That(mvar, [nunit.framework]NUnit.Framework.Constraints.IResolveConstraint)
  ```
