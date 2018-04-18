
import unittest
import tempfile
import os
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


class SimpleTest(unittest.TestCase):
    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_source = os.path.join(self.working_dir, 'hello.c')
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')
        self.file_exe = os.path.join(self.working_dir, 'hello')

        with open(self.file_source, 'w') as f:
            f.write(SOURCE_C)

        self.command = 'scons -C {} -Q'.format(self.working_dir)
        #self.command = command.split()

    def tearDown(self):
        result = subprocess.run('scons -C {} -c -Q'.format(self.working_dir),
                                cwd=self.working_dir,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        shutil.rmtree(self.working_dir)

    def test_program_builder(self):
        with open(self.file_scons, 'w') as f:
            f.write("Program(target ='hello', source = 'hello.c')")

        result = subprocess.run(self.command,
                                cwd=self.working_dir,
                                shell=True)
        self.assertEqual(result.returncode, 0)

        result = subprocess.run(self.file_exe,
                                stdout=subprocess.PIPE,
                                cwd=self.working_dir,
                                shell=True)
        self.assertEqual(result.stdout.decode().strip(), 'Hello, World!')

    def test_object_builder(self):
        with open(self.file_scons, 'w') as f:
            f.write("Object(target = 'hello.o', source = 'hello.c')")

        result = subprocess.run(self.command, cwd=self.working_dir, shell=True)
        self.assertEqual(result.returncode, 0)

        file_object = os.path.join(self.working_dir, 'hello.o')
        self.assertTrue(os.path.isfile(file_object))
        self.assertFalse(os.path.isfile(self.file_exe))


if __name__ == '__main__':
    unittest.main(verbosity=2)
