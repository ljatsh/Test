import unittest
import tempfile
import os
import shutil
import subprocess

SOURCE_H1 = """
int sum(int a, int b);
"""

SOURCE_C1 = """
#include "helper.h"

int sum(int a, int b)
{
    return a + b;
}
"""

SOURCE_C2 = """
#include <stdio.h>
#include "helper.h"

int
main()
{
    printf("%d\\n", sum(1, 2));

    return 0;
}
"""



class SimpleTest(unittest.TestCase):
    def setUp(self):
        self.working_dir = tempfile.mkdtemp()
        self.file_scons = os.path.join(self.working_dir, 'SConstruct')

        with open(os.path.join(self.working_dir, 'helper.h'), 'w') as f:
            f.write(SOURCE_H1)
        with open(os.path.join(self.working_dir, 'helper.c'), 'w') as f:
            f.write(SOURCE_C1)
        with open(os.path.join(self.working_dir, 'main.c'), 'w') as f:
            f.write(SOURCE_C2)

        self.command = 'scons -C {} -Q'.format(self.working_dir)

    def tearDown(self):
        result = subprocess.run('scons -C {} -c -Q'.format(self.working_dir),
                                cwd=self.working_dir,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        shutil.rmtree(self.working_dir)

    def test_glob(self):
        with open(self.file_scons, 'w') as f:
            f.write("Program(target = 'hello', source = Glob('*.c'))")

        result = subprocess.run(self.command, cwd=self.working_dir, shell=True)
        self.assertEqual(result.returncode, 0)

        file_exe = os.path.join(self.working_dir, 'hello')
        result = subprocess.run(file_exe,
                                stdout=subprocess.PIPE,
                                cwd=self.working_dir,
                                shell=True)
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout.decode().strip(), '3')


if __name__ == '__main__':
    unittest.main(verbosity=2)
