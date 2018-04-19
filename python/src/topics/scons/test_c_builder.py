
import unittest
import tempfile
import os
import sys
import shutil
import subprocess


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
            f.writelines(contents)


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
        self.run_command('scons -C {} -c -Q'.format(self.working_dir))
        shutil.rmtree(self.working_dir)

    def build(self):
        return self.run_command('scons -C {} -Q'.format(self.working_dir))

    def check_build_target(self, target):
        result = self.run_command(os.path.join(self.working_dir, target))
        self.assertEqual(result.strip(), '3')

    def check_key_word(self, word, output):
        checked = False

        for line in output:
            if word in line:
                checked = True
                break

        if not checked:
            print(output)
        self.assertTrue(checked)

    def check_build_program(self):
        result = self.build()
        result = [line.strip() for line in result.split('\n') if line.strip()]
        self.check_file_was_compiled('helper.c', result)
        self.check_file_was_compiled('main.c', result)
        self.check_program_was_linked('hello', result)

        self.check_build_target('hello')

    def check_file_was_compiled(self, source, output):
        name, ext = os.path.splitext(source)

        file_object = None
        if sys.platform[:3] == 'win':
            file_object = '{}.{}'.format(name, 'obj')
        else:
            file_object = '{}.{}'.format(name, 'o')

        self.check_key_word('-o {} -c {}'.format(file_object, source), output)

    def check_static_library_was_created(self, target, output):
        if sys.platform[:3] == 'win':
            self.check_key_word('{}.lib'.format(target), output)
        else:
            self.check_key_word('lib{}.a'.format(target), output)

    def check_dynamic_library_was_linked(self, target, output):
        if sys.platform[:3] == 'win':
            self.check_key_word('-o {}.dll'.format(target), output)
        else:
            self.check_key_word('-o lib{}.dylib'.format(target), output)

    def check_program_was_linked(self, target, output):
        self.check_key_word('-o {}'.format(target), output)

    def test_builder_object(self):
        SconsTestBase.createFile(self.file_scons, "Object('helper.c')")

        result = self.build()
        result = [line.strip() for line in result.split('\n') if line.strip()]
        self.check_file_was_compiled('helper.c', result)

    def test_builder_object_with_multiple_sources(self):
        SconsTestBase.createFile(self.file_scons, "Object(['helper.c', 'main.c'])")

        result = self.build()
        result = [line.strip() for line in result.split('\n') if line.strip()]
        self.check_file_was_compiled('helper.c', result)
        self.check_file_was_compiled('main.c', result)

    def test_builder_program(self):
        SconsTestBase.createFile(self.file_scons, "Program(target = 'hello', source = ['helper.c', 'main.c'])")

        self.check_build_program()

    def test_builder_program_with_glob(self):
        SconsTestBase.createFile(self.file_scons, "Program(target = 'hello', source = Glob('*.c'))")

        self.check_build_program()

    def test_builder_static_library(self):
        SconsTestBase.createFile(self.file_scons, "StaticLibrary(target = 'util', source = ['helper.c'])")

        result = self.build()
        result = [line.strip() for line in result.split('\n') if line.strip()]
        self.check_file_was_compiled('helper.c', result)
        self.check_static_library_was_created('util', result)

    def test_builder_dynamic_library(self):
        SconsTestBase.createFile(self.file_scons, "SharedLibrary(target = 'util', source = ['helper.c'])")

        result = self.build()
        result = [line.strip() for line in result.split('\n') if line.strip()]
        self.check_dynamic_library_was_linked('util', result)

    def test_builder_program_with_static_library(self):
        SconsTestBase.createFile(self.file_scons,
                                 "StaticLibrary(target = 'util', source = ['helper.c'])",
                                 "Program(target='hello', source=['main.c'], LIBS='util', LIBPATH='.')")

        self.check_build_program()

    def test_builder_program_with_dynamic_library(self):
        SconsTestBase.createFile(self.file_scons,
                                 "SharedLibrary(target = 'util', source = ['helper.c'])",
                                 "Program(target='hello', source=['main.c'], LIBS='util', LIBPATH='.')")

        self.build()
        self.check_build_target('hello')


if __name__ == '__main__':
    unittest.main(verbosity=2)
