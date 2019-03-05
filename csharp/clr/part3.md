Table of Contents
=================

* [Delegates](#delegates)
  * [Using Delegates to Call Back Many Methods](#using-delegates-to-call-back-many-methods)
  * [C#'s Syntactic Suger for Delegates](#c#'s-syntactic-suger-for-delegates)
  * [Delegate Compability](#delegate-compability)

Delegates
---------

C# hides lots of information behind deletage:

* Every delegate is a new class derived from [MulticastDelegate](https://docs.microsoft.com/en-us/dotnet/api/system.multicastdelegate?view=netcore-2.2)
* C# intepretes [Class|Instance].Method to object and method required by the delegate constructor
* Invoke can be called explicitly to trigger internal methods
* Prefer to use predefined generic delegates --> [Action](https://docs.microsoft.com/en-us/dotnet/api/system.action?view=netcore-2.2) and [Func](https://docs.microsoft.com/en-us/dotnet/api/system.func-1?view=netcore-2.2)

```csharp
internal delegate void Feedback(Int32 value);

.class private auto ansi sealed clr.Feedback extends [netstandard]System.MulticastDelegate
{
  .method public hidebysig specialname rtspecialname instance void .ctor([netstandard]System.Object object, intptr method) cil managed
  {
  } // End of method System.Void clr.Feedback::.ctor(System.Object,System.IntPtr)

  .method public hidebysig newslot virtual instance void Invoke(int32 'value') cil managed
  {
  } // End of method System.Void clr.Feedback::Invoke(System.Int32)

  .method public hidebysig newslot virtual instance [netstandard]System.IAsyncResult BeginInvoke(int32 'value', [netstandard]System.AsyncCallback callback, [netstandard]System.Object object) cil managed
  {
  } // End of method System.IAsyncResult clr.Feedback::BeginInvoke(System.Int32,System.AsyncCallback,System.Object)

  .method public hidebysig newslot virtual instance void EndInvoke([netstandard]System.IAsyncResult result) cil managed
  {
  } // End of method System.Void clr.Feedback::EndInvoke(System.IAsyncResult)
} // End of class clr.Feedback

public static void TestDelegate() {
  Feedback v1 = new Feedback(System.Console.Write);
  v1(1);
  Feedback v2 = new Feedback(new TestWrapper().FeedbackImpl);
  v2(1);
}

.method public hidebysig static void TestDelegate() cil managed
{
  // Code size 48
  .maxstack 2
  .locals init(clr.Feedback V_0, clr.Feedback V_1)
  IL_0000: nop
  IL_0001: ldnull
  IL_0002: ldftn void [netstandard]System.Console::Write(int32)
  IL_0008: newobj instance void clr.Feedback::.ctor([netstandard]System.Object, intptr)
  IL_000d: stloc.0
  IL_000e: ldloc.0
  IL_000f: ldc.i4.1
  IL_0010: callvirt instance void clr.Feedback::Invoke(int32)
  IL_0015: nop
  IL_0016: newobj instance void clr.TestWrapper::.ctor()
  IL_001b: ldftn instance void clr.TestWrapper::FeedbackImpl(int32)
  IL_0021: newobj instance void clr.Feedback::.ctor([netstandard]System.Object, intptr)
  IL_0026: stloc.1
  IL_0027: ldloc.1
  IL_0028: ldc.i4.1
  IL_0029: callvirt instance void clr.Feedback::Invoke(int32)
  IL_002e: nop
  IL_002f: ret
} // End of method System.Void clr.part3::TestDelegate()
```

[Back to TOC](#table-of-contents)

Using Delegates to Call Back Many Methods
-----------------------------------------

* Delegate is immutable
* +/-/+=/-= operators can be intepreted by C# to simplify buildings of delegate chains
* Methods are called sequentially and the final result is the last method return value. If methods throw or you want to process all the return values, you should call every method explicitly, refer [GetInvocationList](https://docs.microsoft.com/en-us/dotnet/api/system.delegate.getinvocationlist?view=netcore-2.2)

```csharp
public static void TestDelegateChain() {
  Feedback v1 = new Feedback(System.Console.Write);
  Feedback v2 = new Feedback(new TestWrapper().FeedbackImpl);

  Feedback v3 = v1 + v2;
  v3(1);
  Feedback v4 = (Feedback)Delegate.Combine(v1, v2);
  v4(1);
}

.method public hidebysig static void TestDelegateChain() cil managed
{
  // Code size 74
  .maxstack 2
  .locals init(clr.Feedback V_0, clr.Feedback V_1, clr.Feedback V_2, clr.Feedback V_3)
  IL_0000: nop
  IL_0001: ldnull
  IL_0002: ldftn void [netstandard]System.Console::Write(int32)
  IL_0008: newobj instance void clr.Feedback::.ctor([netstandard]System.Object, intptr)
  IL_000d: stloc.0
  IL_000e: newobj instance void clr.TestWrapper::.ctor()
  IL_0013: ldftn instance void clr.TestWrapper::FeedbackImpl(int32)
  IL_0019: newobj instance void clr.Feedback::.ctor([netstandard]System.Object, intptr)
  IL_001e: stloc.1
  IL_001f: ldloc.0
  IL_0020: ldloc.1
  IL_0021: call [netstandard]System.Delegate [netstandard]System.Delegate::Combine([netstandard]System.Delegate, [netstandard]System.Delegate)
  IL_0026: castclass clr.Feedback
  IL_002b: stloc.2
  IL_002c: ldloc.2
  IL_002d: ldc.i4.1
  IL_002e: callvirt instance void clr.Feedback::Invoke(int32)
  IL_0033: nop
  IL_0034: ldloc.0
  IL_0035: ldloc.1
  IL_0036: call [netstandard]System.Delegate [netstandard]System.Delegate::Combine([netstandard]System.Delegate, [netstandard]System.Delegate)
  IL_003b: castclass clr.Feedback
  IL_0040: stloc.3
  IL_0041: ldloc.3
  IL_0042: ldc.i4.1
  IL_0043: callvirt instance void clr.Feedback::Invoke(int32)
  IL_0048: nop
  IL_0049: ret
} // End of method System.Void clr.part3::TestDelegateChain()
```

[Back to TOC](#table-of-contents)

C#'s Syntactic Suger for Delegates
----------------------------------

* C# allows you to specify the name of a callback method without having to construct a delegate object wrapper

```csharp
internal sealed class AClass {
  public static void CallbackWithoutNewingADelegateObject() {
    ThreadPool.QueueUserWorkItem(SomeAsyncTask, 5);
  }
  private static void SomeAsyncTask(Object o) {
    Console.WriteLine(o);
  }
}
```

* C# allows you to specify lambda expression to construct a delegate object wrapper

```csharp
internal sealed class AClass {
  private String m_name;  // An instance field
  // An instance method
  public void CallbackWithoutNewingADelegateObject() {
  ThreadPool.QueueUserWorkItem(
    // The callback code can reference instance members.
    obj => Console.WriteLine(m_name + ": " + obj),
    5);
  }
}
```

[Back to TOC](#table-of-contents)

Delegate Compability
--------------------

Parameter compatibility

* A delegate can have more specific parameter types than its method target. This is called contravariance
* The standard event pattern is designed to help you leverage contravariance through its use of the common EventArgs base class. For example, you can have a single method invoked by two different delegates, one passing a MouseEventArgs and the other passing a KeyEventArgs.

```csharp
delegate void StringAction (string s);
class Test {
  static void Main() {
    StringAction sa = new StringAction (ActOnObject);
    sa ("hello");
  }
  static void ActOnObject (object o) {
    Console.WriteLine (o);   // hello
  }
}
```

Return type compatibility

* A delegate target method may return a more specific type than described by the delegate. This is called covariance.

```csharp
delegate object ObjectRetriever();
class Test {
  static void Main()
  {
    ObjectRetriever o = new ObjectRetriever (RetriveString);
    object result = o();
    Console.WriteLine (result);      // hello
  }
  static string RetriveString() { return "hello"; }
}
```

[Back to TOC](#table-of-contents)
