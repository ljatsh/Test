
import unittest
import tempfile
import os
import sys
import shutil
import subprocess
import time

"""
1. Always choose MD5 decider. It seems timestamp is not reliable(TODO)
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

    def build(self):
        result = self.run_command('scons -C {} -Q'.format(self.working_dir))
        return [line.strip() for line in result.split('\n') if line.strip()]

    def check_built_target(self, target):
        result = self.run_command(os.path.join(self.working_dir, target))
        self.assertEqual(result.strip(), '3')

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

if __name__ == '__main__':
    unittest.main(verbosity=2)
