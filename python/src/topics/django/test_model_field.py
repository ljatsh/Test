
import unittest

from django.db import models

class TestModel(models.Model):
    name = models.TextField(null=True)

class ModelFieldTest(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_field(self):
        test = TestModel()

if __name__ == '__main__':
    unittest.main()