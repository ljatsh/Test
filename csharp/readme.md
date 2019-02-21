Table of Contents
=================

* [dev environment](#dev_env)
* [ildsam](#ildsam)
* [todo](#todo)

dev_env
-------

* [common language infustructure](http://www.ecma-international.org/publications/standards/Ecma-335.htm)
* [csharp language reference](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/index)
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
* [CIL Instructions](https://en.wikipedia.org/wiki/List_of_CIL_instructions)
* [il assembly language](https://www.codeproject.com/Articles/3778/Introduction-to-IL-Assembly-Language)
* Method Flags
  Accessibility flags (mask 0x0007), which are similar to the accessibility flags of fields:
  * privatescope (0x0000): This is the default accessibility. A private scope method is exempt from the requirement of having a unique triad of owner, name, and signature and hence must always be referenced by a MethodDef token and never by a MemberRef token. The privatescope methods are accessible (callable) from anywhere within current module.
  * private (0x0001): The method is accessible from its owner class and from classes nested in the method’s owner.
  * famandassem (0x0002): The method is accessible from types belonging to the owner’s family—that is, the owner itself and all its descendants—defined in the current assembly.
  * Accessibility flags (mask 0x0007), which are similar to the accessibility flags of fields:
  * assembly (0x0003): The method is accessible from types defined in the current assembly.
  * family (0x0004): The method is accessible from the owner’s family.
  * famorassem (0x0005): The method is accessible from the owner’s family and from all types defined in the current assembly.
  * public (0x0006): The method is accessible from any type.assembly (0x0003): The method is accessible from types defined in the current assembly.

  Contract flags (mask 0x00F0):
  * static (0x0010): The method is static, shared by all instances of the type.
  * final (0x0020): The method cannot be overridden. This flag must be paired with the virtual flag; otherwise, it is meaningless and is ignored.
  * virtual (0x0040): The method is virtual. This flag cannot be paired with the static flag.
  * hidebysig (0x0080): The method hides all methods of the parent classes that have a matching signature and name (as opposed to having a matching name only). This flag is ignored by the common language runtime and is provided for the use of compilers only. The IL assembler recognizes this flag but does not use it.

  Virtual method table (v-table) control flags (mask 0x0300):
  * newslot (0x0100): A new slot is created in the class’s v-table for this virtual method so that it does not override the virtual method of the same name and signature this class inherited from its base class. This flag can be used only in conjunction with the virtual flag.
  * strict (0x0200): This virtual method can be overridden only if it is accessible from the overriding class. This flag can be used only in conjunction with the virtual flag.

  Implementation flags (mask 0x2C08):
  * abstract (0x0400): The method is abstract; no implementation is provided. This method must be overridden by the nonabstract descendants of the class owning the abstract method. Any class owning an abstract method must have its own abstract flag set. The RVA entry of an abstract method record must be 0.
  * pecialname (0x0800): The method is special in some way, as described by the name.
  * pinvokeimpl( <pinvoke_spec> ) (0x2000): The method has an unmanaged implementation and is called through the platform invocation mechanism P/Invoke, discussed in Chapter 18. <pinvoke_spec> in parentheses defines the implementation map, which is a record in the ImplMap metadata table specifying the unmanaged DLL exporting the method and the method’s unmanaged calling convention. If the DLL name in <pinvoke_spec> is provided, the method’s RVA must be 0, because the method is implemented externally. If the DLL name is not specified or the <pinvoke_spec> itself is not provided—that is, the parentheses are empty—the defined method is a local P/Invoke, implemented in unmanaged native code embedded in the current PE file;
  in this case, its RVA must not be 0 and must point to the location, in the current PE file, of the native method’s body.
  * unmanagedexp (0x0008): The managed method is exposed as an unmanaged export. This flag is not currently used by the common language runtime.abstract (0x0400): The method is abstract; no implementation is provided. This method must be overridden by the nonabstract descendants of the class owning the abstract method. Any class owning an abstract method must have its own abstract flag set. The RVA entry of an abstract method record must be 0.

  Reserved flags (cannot be set explicitly; mask 0xD000):
  * rtspecialname (0x1000): The method has a special name reserved for the internal use of the runtime. Four method names are reserved: .ctor for instance constructors, .cctor for class constructors, _VtblGap* for v-table placeholders, and _Deleted* for methods marked for deletion but not actually removed from metadata. The keyword rtspecialname is ignored by the IL assembler and is displayed by the IL disassembler for informational purposes only. This flag must be accompanied by a specialname flag.
  * [no ILAsm keyword] (0x4000): The method either has an associated DeclSecurity metadata record that holds security details concerning access to the method or has the associated custom attribute System.Security. SuppressUnmanagedCodeSecurityAttribute.
  * reqsecobj (0x8000): This method calls another method containing a security code, so it requires an additional stack slot for a security object. This flag is formally under the Reserved mask, so it cannot be set explicitly. Setting this flag requires emitting the pseudocustom attribute System.Security.DynamicSecurityMethodAttribute. When the IL assembler encounters the keyword reqsecobj, it does exactly that: emits the pseudocustom attribute and thus sets this “reserved” flag. Since anybody can set this flag by emitting the pseudocustom attribute, I wonder what the reason was for putting this flag under the Reserved mask. This flag could just as well been left as assignable.

todo
----
