
# -*- coding: utf-8

"""
Reference: https://docs.python.org/3/howto/regex.html#regex-howto
           http://127.0.0.1:8010/python/python-3.6.2-docs-html/library/re.html?highlight=regex#module-re

1. There are following meta characters:
   . * ? + {} [ ] ^ $ | \ ( )
   Meta characters are not active in classes.
2. Escape all meta characters although you can avoid to do so in classes.
3. Prefer raw string while constructing re compilers

Hints:
1. Repetition is greedy.

"""

import unittest
import re


class ReTest(unittest.TestCase):
    def setUp(self):
        pass

    def tearDown(self):
        pass

    def test_meta_character_not_active(self):
        self.assertRegex('_._', r'[\.]')
        self.assertRegex('_*_', r'[\*]')
        self.assertRegex('_?_', r'[\?]')
        self.assertRegex('_+_', r'[\+]')
        self.assertRegex('_{_', r'[\{]')
        self.assertRegex('_}_', r'[\}]')
        self.assertRegex('_[_', r'[\[]')
        self.assertRegex('_]_', r'[\]]')
        self.assertRegex('_^_', r'[\^]')
        self.assertRegex('_$_', r'[\$]')
        self.assertRegex('_|_', r'[\|]')
        # avoid following writings
        self.assertRegex('_\_', '[\\\\]')
        self.assertRegex('_\_', r'[\\]')
        self.assertRegex('_(_', r'[\(]')
        self.assertRegex('_)_', r'[\)]')

        for i in '.*?+{}[]^$|\\()':
            self.assertRegex('_{}_'.format(i), r'_[.*?+{}\[\]\^$|\\\(\)]_')

    def test_predefined_characters_digit(self):
        self.assertRegex('15131314', r'\d+')
        self.assertRegex('abc', r'\D+')

    def test_predefined_characters_whitespaces(self):
        self.assertRegex(' ', r'\s')
        self.assertRegex('\t', r'\s')
        self.assertRegex('\r', r'\s')
        self.assertRegex('\n', r'\s')

        self.assertNotRegex('Hello, Python!', r'^\S+$')

    def test_predefined_characters_alphanumeric(self):
        self.assertRegex('_value_1', r'[%w_]+')

    def test_match(self):
        """
        match is matching from the beginning
        """
        pattern = re.compile(r'\w+')
        matched = pattern.match('name = ljatsh')
        self.assertIsNotNone(matched)
        self.assertEqual(matched.group(), 'name')
        self.assertEqual(matched.start(), 0)
        self.assertEqual(matched.end(), 4)
        self.assertEqual(matched.span(), (0, 4))

        self.assertIsNone(pattern.match(' name = ljatsh'))

    def test_search(self):
        pattern = re.compile(r'\w+')
        matched = pattern.search(' name = ljatsh')
        self.assertIsNotNone(matched)
        self.assertEqual(matched.group(), 'name')
        self.assertEqual(matched.start(), 1)
        self.assertEqual(matched.end(), 5)
        self.assertEqual(matched.span(), (1, 5))

    def test_findall(self):
        pattern = re.compile(r'\d+')
        result = pattern.findall('12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
        self.assertEqual(result, ['12', '11', '10'])

        result = [int(x.group()) for x in pattern.finditer('12 drummers drumming, 11 pipers piping, 10 lords a-leaping')]
        self.assertEqual(result, [12, 11, 10])



if __name__ == '__main__':
    unittest.main(verbosity=2)
