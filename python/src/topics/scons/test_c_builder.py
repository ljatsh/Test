
import unittest
import tempfile
import os
import sys
import shutil
import subprocess
import time

"""
Reference: https://scons.org/doc/3.0.1/HTML/scons-user/
1. Always choose MD5 decider. It seems timestamp is not reliable(TODO)
2. Regarding Environment:
   1) Avoids to use external Environment. The relationship between the external environment and DefaultEnvironment or
      another Construction Environment is confusion.
   1) Useful method of Construction Environment: Clone, Replace, SetDefault, Append, AppendUnique, Prepend, PrependUnique
   2) Execution environment overrides the environment itself.
   
3. How to get default Builder relevant construction variables?
   1. env.ParseFlags
   2. Print relevant Construction Vairables.
   
4. C Builder relevant construction variables(http://pages.cs.wisc.edu/~driscoll/software/scons/variables.html):
   1. C and C++ compiling
      1) CCFLAGS: It is passed as part of the command line for compiling C and C++ files.
      2) CFLAGS, CXXFLAGS: flags passed to the C compiler (but not C++ compiler) and vice versa, respectively.
      3) CPPDEFINES: a collection of preprocessor definition flags. It can be a single string, a list, or a dictionary.
         For the dictionary, it should have a form similar to {'FOO' : 'foo', 'BAR' : None} which will get translated
         to the flags -DBAR -DFOO=foo or /DBAR /DFOO=foo depending on the compiler.
      4) CPPPATH: a list of directories that should be searched for include files (both by the compiler,
         via the -I flag or similar, and by SCons when scanning implicit dependencies).
      5) CC, CXX: the C and C++ compiler to use
      
   2. Linking
      1) LINKFLAGS: flags to pass to the linker
      2) RPATH: a list of directories to -Wl,-rpath into the program; using this requires not overwriting $LINKFLAGS
         completely.
      3) LIBPATH: a list of directories that should be search for libraries (both by the linker, via the -L flag or
         similar, and by SCons when scanning for changes).
      4) LIBS: a list of libraries to link against (gets translated to a series of -l flags to GCC). Don't include the
         lib prefix on Linux or .so or .lib suffix.
      5) LINK: the name of the linker
      
5. Good Practices:
   1. Use Install with Alias together. Don't install files under the Sconscript directory.
   2. Avoid to reference the path related to top-level SConsturct directory.(#path)
   3. Avoid to use the imported environment directly. Clone it firstly.
   4. Avoid to set variant build information in SConscript. Set them in top-level SConstruct instead.
   5. Prefer Builders created with a generator. The generator can return command string or another action. It is much
      more flexible. Construction Variable Substitution is very powerful in command string.
   6. Python Action does not check target after building.
"""


SOURCE_C = """
#include <stdio.h>

int
main()
{
    printf("Hello, World!\\n");
    
    return 0;
}
"""


Source_H_Helper = """
int sum(int a, int b);
"""

Source_C_Helper = """
#include "helper.h"

int sum(int a, int b)
{
    return a + b;
}
"""

Source_C_Main = """
#include <stdio.h>
#include "helper.h"

int
main()
{
    printf("%d\\n", sum(1, 2));

    return 0;
}
"""


class SconsTestBase(unittest.TestCase):

    @staticmethod
    def createFile(path, *contents):
        real_path = os.path.realpath(path)
        dirname = os.path.dirname(real_path)
        if not os.path.exists(dirname):
            os.mkdir(dirname)

        with open(real_path, 'w') as f:
            for line in contents:
                f.write(line)
                f.write('\n')

    @staticmethod
    def appendContent2File(path, *contents):
        with open(path, 'a') as f:
            for line in contents:
                f.writelines(line)
                f.write('\n')

    def check_key_word_exists(self, word, output):
        found = False

        for line in output:
            if word in line:
                found = True
                break

        if not found:
            print(output)
        self.assertTrue(found)

    def check_key_word_not_exist(self, word, output):
        found = False

        for line in output:
            if word in line:
                found = True
                break

        if found:
            print(output)
        self.assertFalse(found)


class CBuilderTest(SconsTestBase):
    def run_command(self, command):
        result = subprocess.run(command,
                                cwd=self.working_dir,
                                stdout=subprocess.PIPE,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        return result.stdout.decode()

    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')

        SconsTestBase.createFile(os.path.join(self.working_dir, 'helper.h'), Source_H_Helper)
        SconsTestBase.createFile(os.path.join(self.working_dir, 'helper.c'), Source_C_Helper)
        SconsTestBase.createFile(os.path.join(self.working_dir, 'main.c'), Source_C_Main)

    def tearDown(self):
        if os.path.exists(self.file_scons):
            self.run_command('scons -C {} -c -Q'.format(self.working_dir))
        shutil.rmtree(self.working_dir)

    def build(self, target=None):
        result = self.run_command('scons -C {} -Q {}'.format(self.working_dir, target or ''))
        return [line.strip() for line in result.split('\n') if line.strip()]

    def check_built_target(self, target):
        result = self.run_command(os.path.join(self.working_dir, target))
        self.assertEqual(result.strip(), '3')

    def check_program_building_without_shared_library(self):
        result = self.build()
        self.check_file_was_compiled('helper.c', result)
        self.check_file_was_compiled('main.c', result)
        self.check_program_was_linked('hello', result)

        self.check_built_target('hello')

        return result

    def check_file_was_compiled(self, source, output):
        self.check_file_was_compiled_or_not(source, output, compiled=True)

    def check_file_was_not_compiled(self, source, output):
        self.check_file_was_compiled_or_not(source, output, compiled=False)

    def check_file_was_compiled_or_not(self, source, output, compiled=True):
        name, ext = os.path.splitext(source)

        file_object = None
        if sys.platform[:3] == 'win':
            file_object = '{}.{}'.format(name, 'obj')
        else:
            file_object = '{}.{}'.format(name, 'o')

        if compiled:
            self.check_key_word_exists('-o {} -c {}'.format(file_object, source), output)
        else:
            self.check_key_word_not_exist('-o {} -c {}'.format(file_object, source), output)

    def check_static_library_was_created(self, target, output):
        if sys.platform[:3] == 'win':
            self.check_key_word_exists('{}.lib'.format(target), output)
        else:
            self.check_key_word_exists('lib{}.a'.format(target), output)

    def check_dynamic_library_was_linked(self, target, output):
        if sys.platform[:3] == 'win':
            self.check_key_word_exists('-o {}.dll'.format(target), output)
        elif sys.platform[:3] == 'dar':
            self.check_key_word_exists('-o lib{}.dylib'.format(target), output)
        else:
            self.check_key_word_exists('-o lib{}.so'.format(target), output)

    def check_program_was_linked(self, target, output):
        self.check_key_word_exists('-o {}'.format(target), output)

    def check_program_was_not_linked(self, target, output):
        self.check_key_word_not_exist('-o {}'.format(target), output)

    def test_builder_object(self):
        SconsTestBase.createFile(self.file_scons, "Object('helper.c')")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)

    def test_builder_object_with_multiple_sources(self):
        SconsTestBase.createFile(self.file_scons, "Object(['helper.c', 'main.c'])")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)
        self.check_file_was_compiled('main.c', result)

    def test_builder_program(self):
        SconsTestBase.createFile(self.file_scons, "Program(target = 'hello', source = ['helper.c', 'main.c'])")

        self.check_program_building_without_shared_library()

    def test_builder_program_with_glob(self):
        SconsTestBase.createFile(self.file_scons, "Program(target = 'hello', source = Glob('*.c'))")

        self.check_program_building_without_shared_library()

    def test_builder_static_library(self):
        SconsTestBase.createFile(self.file_scons, "StaticLibrary(target = 'util', source = ['helper.c'])")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)
        self.check_static_library_was_created('util', result)

    def test_builder_dynamic_library(self):
        SconsTestBase.createFile(self.file_scons, "SharedLibrary(target = 'util', source = ['helper.c'])")

        result = self.build()
        self.check_dynamic_library_was_linked('util', result)

    def test_builder_program_with_static_library(self):
        SconsTestBase.createFile(self.file_scons,
                                 "StaticLibrary(target = 'my_util', source = ['helper.c'])",
                                 "Program(target='hello', source=['main.c'], LIBS='my_util', LIBPATH='.')")

        self.check_program_building_without_shared_library()

    def test_builder_program_with_dynamic_library(self):
        SconsTestBase.createFile(self.file_scons,
                                 "SharedLibrary(target = 'my_util', source = ['helper.c'])",
                                 "Program(target='hello', source=['main.c'], LIBS='my_util', LIBPATH='.')")

        self.build()
        ## error while loading shared libraries: libmy_util.so: cannot open shared object file: No such file or directory
        if sys.platform != 'linux':
            self.check_built_target('hello')

    def test_builder_return_node(self):
        SconsTestBase.createFile(self.file_scons,
                                 "file_objects = Object(source = ['helper.c', 'main.c'])",
                                 "print('{!r}'.format(file_objects))",
                                 "print('names of the node:', ' '.join(x.name for x in file_objects))",
                                 "Program(target = 'hello', source = file_objects)")

        result = self.check_program_building_without_shared_library()
        self.check_key_word_exists("('names of the node:', 'helper.o main.o')", result)
        self.check_key_word_exists("SCons.Node.FS.Entry object at", result)

    def test_create_node_explicitly(self):
        SconsTestBase.createFile(self.file_scons,
                                 "file_objects = Object(source = [File('helper.c'), Entry('main.c')])",
                                 "Program(target = 'hello', source = file_objects)")

        result = self.check_program_building_without_shared_library()

    @unittest.skip('GetBuildPath TODO')
    def test_build_path(self):
        pass

    def test_decider_md5(self):
        """
        Under MD5 decider, source file was compiled but program was not linked again
        (dependant on compiler implementation)
        """
        SconsTestBase.createFile(self.file_scons,
                                 "file_objects = Object(source = ['helper.c', 'main.c'])",
                                 "Program(target = 'hello', source = file_objects)",
                                 "Decider('MD5')"
                                 "#Decider('content') #content is a synonym of MD5 "
                                 )

        self.check_program_building_without_shared_library()

        time.sleep(1)
        self.appendContent2File(os.path.join(self.working_dir, 'helper.c'),
                                "// This is just a comment")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)
        self.check_program_was_not_linked('hello', result)

    @unittest.skip("timestamp is unreliable")
    def test_decider_timestamp1(self):
        SconsTestBase.createFile(self.file_scons,
                                 "file_objects = Object(source = ['helper.c', 'main.c'])",
                                 "Program(target = 'hello', source = file_objects)",
                                 "Decider('timestamp-newer')"
                                 "#Decider('make') # make is a synonym of timestamp-newer"
                                 "#Decider('timestamp-match') # match is more strict than newer"
                                 )

        self.check_program_building_without_shared_library()

        ## the timestamp check wont' work if we sleep less than 1 second! It is intresting.
        ## I think timestamp-newer decider is unreliable!
        #time.sleep(1)
        self.appendContent2File(os.path.join(self.working_dir, 'helper.c'),
                                "// This is just a comment")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)
        self.check_program_was_linked('hello', result)


    @unittest.skip('Customization--->Decider TODO')
    def test_customize_decider(self):
        pass

    def test_dependency_depends(self):
        SconsTestBase.createFile(self.file_scons,
                                 "file_object = Object('helper.c')",
                                 "Depends(file_object, 'main.c')")

        result = self.build()
        self.check_file_was_compiled('helper.c', result)

        result = self.build()
        self.check_file_was_not_compiled('helper.c', result)

        self.appendContent2File(os.path.join(self.working_dir, 'main.c'),
                                "// This is just a comment")
        result = self.build()
        self.check_file_was_compiled('helper.c', result)

    def test_dependency_ignore(self):
        """
        Ignore breaks the dependency between target and source. It can also prevents generated files from
        being built by default. But the file will still be built if the user specifically requests the
        target on scons command line.
        """
        SconsTestBase.createFile(self.file_scons,
                                 "file_object = Object(['helper.c', 'main.c'])",
                                 "target = Program(target = 'hello', source = file_object)",
                                 "generates = target",
                                 "generates.extend(file_object)",
                                 "Ignore('.', generates)")

        result = self.build()
        self.check_file_was_not_compiled('helper.c', result)
        self.check_file_was_not_compiled('main.c', result)

        result = self.build(target='hello')

        self.check_program_was_linked('hello', result)

    def test_dependency_order_only(self):
        """
        Requires only makes sure the dependencies are built prior to the target. It does not require the
        target should be rebuilt when the dependencies are rebuilt.
        """
        SconsTestBase.createFile(self.file_scons,
                                 "helper = Object(source = ['helper.c'])",
                                 "target = Program(target = 'hello', source = ['main.c'], LINKFLAGS=str(helper[0]))",
                                 "Requires(target, helper)"
                                 )

        self.check_program_building_without_shared_library()

        self.appendContent2File(os.path.join(self.working_dir, 'helper.c'),
                                "// This is just a comment")
        result = self.build(target='hello')
        self.check_file_was_compiled('helper.c', result)
        self.check_program_was_not_linked('hello', result)


class EnvironmentTest(SconsTestBase):

    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')

    def tearDown(self):
        shutil.rmtree(self.working_dir)

    def run_command(self, command):
        result = subprocess.run(command,
                                cwd=self.working_dir,
                                stdout=subprocess.PIPE,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        return result.stdout.decode()

    def build(self, target=None):
        result = self.run_command('scons -C {} -Q {}'.format(self.working_dir, target or ''))
        return [line.strip() for line in result.split('\n') if line.strip()]

    @unittest.skip('avoid to use external environment')
    def test_external_environment(self):
        SconsTestBase.createFile(self.file_scons,
                                 "env = DefaultEnvironment()",
                                 "print(env.subst('$CCFLAGS') or 'empty')"
                                 )

        result = self.build()
        print(result)

        os.environ['CCFLAGS'] = '-O2 -g'
        #self.appendContent2File(self.file_scons, 'import os')
        SconsTestBase.createFile(self.file_scons,
                                 "import os",
                                 "print(os.environ['CCFLAGS'])",
                                 #"env = DefaultEnvironment(CCFLAGS=os.environ['CCFLAGS'])",
                                 #"print(env.subst('$CCFLAGS') or 'empty')",
                                 "Program('main.c')"
                                 )

        SconsTestBase.createFile(os.path.join(self.working_dir, 'main.c'),
                                "int main() { return 0; }")

        result = self.build()
        print(result)

    def test_environment_construction_environment(self):
        SconsTestBase.createFile(self.file_scons,
                                 "env=Environment(CC = 'gcc',",
                                 "                CCFLAGS = '-O2 -g')",
                                 "print('CC = {}'.format(env['CC']))",
                                 "print('CCFLAGS = {}'.format(env.subst('$CCFLAGS')))")

        result = self.build()
        self.check_key_word_exists('CC = gcc', result)
        self.check_key_word_exists('CCFLAGS = -O2 -g', result)

    def test_environment_value_expansion_exception(self):
        SconsTestBase.createFile(self.file_scons,
                                 "env=Environment()",
                                 "print('InvalidValue = {}_Placeholder'.format(env.subst('$InvalidValue')))")

        result = self.build()
        self.check_key_word_exists('InvalidValue = _Placeholder', result)

        # AllowSubstExceptions must be put in the front of SConstruct
        self.appendContent2File(self.file_scons, "AllowSubstExceptions()")
        self.check_key_word_exists('InvalidValue = _Placeholder', result)

        SconsTestBase.createFile(self.file_scons,
                                 "AllowSubstExceptions()",
                                 "env=Environment()",
                                 "print('InvalidValue = {}_Placeholder'.format(env.subst('$InvalidValue')))")
        result = subprocess.run('scons -C {} -Q'.format(self.working_dir),
                                cwd=self.working_dir,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE,
                                shell=True)
        self.assertNotEqual(result.returncode, 0)

    def test_environment_execution_environment(self):
        SconsTestBase.createFile(self.file_scons,
                                 "env = Environment(CCFLAGS = '-O1 -g')",
                                 "env.Program('main.c', CCFLAGS = '-O2')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'main.c'),
                                 "int main() { return 0; }")

        result = self.build()
        self.check_key_word_exists('-O2 main.c', result)
        self.check_key_word_not_exist('-O1 -g main.c', result)

    @unittest.skip('find construction variables regarding default Builder')
    def test_environment_get_construction_variables(self):
        SconsTestBase.createFile(self.file_scons,
                                 "for k, v in sorted(DefaultEnvironment().Dictionary().items()):",
                                 "    if v:",
                                 "        print(k, v)")

        result = self.build()
        print(result)

    def test_environment_parse_and_merge_flags(self):
        """
        If you do not known how to find relevant construction variables regarding builders, you can ask for help
        from env.ParseFlags
        """

        SconsTestBase.createFile(self.file_scons,
                                 "env = Environment()",
                                 "d = env.ParseFlags('-I/tmp/include -g -O2 -L/tmp -lm -L/usr/local/lib -w')",
                                 "for k, v in sorted(d.items()):",
                                 "    if v:",
                                 "        print(k, v)",
                                 "env.MergeFlags(d)",
                                 "env.Program('main.c')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'main.c'),
                                 "int main() { return 0; }")

        result = self.build()
        self.check_key_word_exists("'CCFLAGS', ['-g', '-O2', '-w']", result)
        self.check_key_word_exists("'CPPPATH', ['/tmp/include']", result)
        self.check_key_word_exists("'LIBPATH', ['/tmp', '/usr/local/lib']", result)
        self.check_key_word_exists("'LIBS', ['m']", result)


class CustomizedBuilderTest(SconsTestBase):
    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')

        self.other_dir = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.working_dir)
        shutil.rmtree(self.other_dir)

    def run_command(self, command):
        result = subprocess.run(command,
                                cwd=self.working_dir,
                                stdout=subprocess.PIPE,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        return result.stdout.decode()

    def build(self, target=None):
        result = self.run_command('scons -C {} -Q {}'.format(self.working_dir, target or ''))
        return [line.strip() for line in result.split('\n') if line.strip()]

    def test_builder_execute_external_command(self):
        """
        This test cannot run on Windows
        """
        SconsTestBase.createFile(self.file_scons,
                                 "builder_cp = Builder(action = 'cp $SOURCE $TARGET',",
                                 "                     suffix = 'out',",
                                 "                     prefix = 'build_',",
                                 "                     src_suffix = 'in')",
                                 "env = Environment()",
                                 "env.Append(BUILDERS = {'cp': builder_cp})",
                                 "env.cp('test')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'test.in'))

        result = self.build()
        self.check_key_word_exists('cp test.in build_test.out', result)

    def test_builder_execute_function(self):
        SconsTestBase.createFile(self.file_scons,
                                 "def echo(target, source, env):",
                                 "    pass",
                                 "builder_echo = Builder(action = echo,",
                                 "                       suffix = 'out',",
                                 "                       src_suffix = 'in')",
                                 "env = Environment()",
                                 "env.Append(BUILDERS = {'echo': builder_echo})",
                                 "env.echo('test')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'test.in'))

        result = self.build()
        self.check_key_word_exists('echo(["test.out"], ["test.in"])', result)

    def test_builder_execute_generator(self):
        SconsTestBase.createFile(self.file_scons,
                                 "def cp(target, source, env, for_signature):",
                                 "    return 'cp {} {}'.format(source[0], target[0])",
                                 #"    return 'cp $SOURCE $TARGET'", Construction Variable Substitution
                                 "builder_cp = Builder(generator = cp,",
                                 "                     suffix = 'out',",
                                 "                     src_suffix = 'in')",
                                 "env = Environment()",
                                 "env.Append(BUILDERS = {'cp': builder_cp})",
                                 "env.cp('test')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'test.in'))

        result = self.build()
        print(result)


class GoodPracticeTest(SconsTestBase):
    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')

        self.other_dir = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.working_dir)
        shutil.rmtree(self.other_dir)

    def run_command(self, command):
        result = subprocess.run(command,
                                cwd=self.working_dir,
                                stdout=subprocess.PIPE,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        return result.stdout.decode()

    def build(self, target=None):
        result = self.run_command('scons -C {} -Q {}'.format(self.working_dir, target or ''))
        return [line.strip() for line in result.split('\n') if line.strip()]

    def test_install(self):
        """
        Don't use install files under current directory. It seems install is designed for another directory.
        Use Install function with Alias together.
        """

        SconsTestBase.createFile(self.file_scons,
                                 "env = Environment()",
                                 "hello = env.Program(target = 'hello', source = 'main.c')",
                                 "env.Install('{}', hello)".format(self.other_dir),
                                 "env.Alias('install', '{}')".format(self.other_dir))

        SconsTestBase.createFile(os.path.join(self.working_dir, 'main.c'),
                                 'int main() { return 0; }')

        result = self.build()
        self.check_key_word_not_exist('Install file:', result)

        result = self.build('install')
        self.check_key_word_exists('Install file:', result)

    def test_hierarchical(self):
        SconsTestBase.createFile(self.file_scons,
                                 "env_debug = Environment(CPPFLAGS = '-g')",
                                 "Export('env_debug')",
                                 "SConscript(['prog1/SConscript', 'prog2/SConscript'])")

        # prog１
        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog1/SConscript'),
                                 "Import('env_debug')",
                                 "env = env_debug.Clone()",
                                 "env.Program('prog1', 'main.c')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog1/main.c'),
                                 'int main() { return 0; }')

        # prog２
        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog2/SConscript'),
                                 "Program('prog1', 'main.c')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog2/main.c'),
                                 'int main() { return 0; }')


        result = self.build()
        self.check_key_word_exists(' -g ', result)

    def test_variant(self):
        """
        It seems scons cannot work if variant_dir is other directory.
        """
        SconsTestBase.createFile(self.file_scons,
                                 "SConscript('prog1/SConscript', variant_dir = 'build/prog1', duplicate = 0)",
                                 "SConscript('prog2/SConscript', variant_dir = 'build/prog2', duplicate = 0)")

        # prog１
        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog1/SConscript'),
                                 "Program('prog1', 'main.c')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog1/main.c'),
                                 'int main() { return 0; }')

        # prog２
        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog2/SConscript'),
                                 "Program('prog1', 'main.c')")

        SconsTestBase.createFile(os.path.join(self.working_dir, 'prog2/main.c'),
                                 'int main() { return 0; }')

        result = self.build()
        self.check_key_word_exists('main.c', result)


if __name__ == '__main__':
    unittest.main(verbosity=2)
