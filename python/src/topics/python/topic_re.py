
# -*- coding: utf-8

"""
Reference: https://docs.python.org/3/howto/regex.html#regex-howto

1. There are following meta characters:
   . * ? + {} [ ] ^ $ | \ ( )
   Meta characters are not active in classes.
2. Escape all meta characters although you can avoid to do so in classes.
3. Prefer raw string while constructing patterns.
4. When multiline flag was not set, ^ matches at the beginning of the line and $ matches at then end of the line
   (or character followed by the last \n)
5. End of the span(matched object) is a invalid index.
6. \w also contains underscore!
7. Index of every matched object are based from the beginning of the string.

Hints:
1. Repetition is greedy.

Best Practice:
1. Avoid to match multiple lines if you can. Be careful with meta character '.' and '$'

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
            self.assertRegex('_{}_'.format(i), r'_[\.\*\?\+\{\}\[\]\^\$\|\\\(\)]_')

    def test_meta_character_boundary(self):
        self.assertNotRegex('this is a test_file', r'\btest\b')
        self.assertRegex('this is a test_file', r'test')
        self.assertRegex('test file', r'\btest\b', 'begin of the string is boundary')
        self.assertRegex('file test', r'\btest\b', 'end of the string is also boudary')

    def test_meta_character_begin(self):
        """
        ^ matches at the beginning of the line
        """
        self.assertNotRegex(' lj from China', r'^\blj\b')
        self.assertRegex('lj from China', r'^\blj\b')
        s = """
lj from China.
Keith from America.
lj like logs
"""
        matched = re.findall(r'^\blj\b', s, re.MULTILINE)
        self.assertEqual(len(matched), 2)

    def test_meta_character_end(self):
        """
        $ matches at the end of the line
        """
        self.assertIsNotNone(re.search(r'\btest$', 'this is a test'),
                             'End of the line can be the end of the string')
        self.assertIsNotNone(re.search(r'\btest$', 'this is a test\n'),
                             'End of the line can also be any location followed by a newline character')
        self.assertIsNone(re.search(r'\btest$', 'this is a test\n\n'),
                             'The pattern does not match')
        self.assertIsNone(re.search(r'\btest$', 'this is a test\r'), 'Invalid end of line')

        matched = re.findall(r'\btest$', '1. test\n2.test\r\n3.test\n4. test\n')
        self.assertEqual(len(matched), 1, 'The 4th one is matched')
        matched = re.findall(r'\btest$', '1. test\n2.test\r\n3.test\n4. test \n', re.MULTILINE)
        self.assertEqual(len(matched), 2)

    def test_predefined_characters_digit(self):
        self.assertEqual(re.match(r'\d+', '15131314').span(), (0, 8))
        self.assertEqual(re.search(r'\D+', '2b1').span(), (1, 2))

    def test_predefined_characters_whitespaces(self):
        self.assertRegex(' ', r'\s')
        self.assertRegex('\t', r'\s')
        self.assertRegex('\r', r'\s')
        self.assertRegex('\n', r'\s')

        self.assertNotRegex('Hello, Python!', r'^\S+$')

    def test_predefined_characters_alphanumeric(self):
        self.assertRegex('_', r'\w', r"\w also contains underscore")
        self.assertEqual(re.search(r'[^_]\w{4}', '_value_1').group(), 'value')

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
        self.assertEqual(matched.span(), (0, 4), 'second value of the span is invalid')

        self.assertIsNone(pattern.match(' name = ljatsh'))

    def test_search(self):
        """
        search looks for any location of the string
        """
        pattern = re.compile(r'\w+')
        matched = pattern.search(' name = ljatsh')
        self.assertIsNotNone(matched)
        self.assertEqual(matched.group(), 'name')
        self.assertEqual(matched.start(), 1)
        self.assertEqual(matched.end(), 5)
        self.assertEqual(matched.span(), (1, 5))

    def test_findall(self):
        result = re.findall(r'\b\w\b', 'test_file_is_ok')
        self.assertEqual(result, [], 'empty list is returned if no match')

        result = re.findall(r'\d+', '12 drummers drumming, 11 pipers piping, 10 lords a-leaping')
        self.assertEqual(result, ['12', '11', '10'])

        result = re.findall(r'(\d{2})/\d{2}/\d{4}', 'year 11/12/2012. Year 12/12/2014. Go.')
        self.assertEqual(result, ['11', '12'],
                         'A list of groups is returned if there are one or more groups are present in the pattern')

    def test_finditer(self):
        matched = [x for x in re.finditer(r'\blj\b', """
        lj from China.
        Keith from America.
        lj like dogs

""", re.MULTILINE)]
        self.assertEqual(len(matched), 2)
        self.assertNotEqual(matched[0].start(), matched[1].start(),
                            'all span indexes are from the first character in the search string')

    def test_flags_ignore(self):
        self.assertIsNone(re.search(r'\s+hate\s+', 'I hAte you.'))
        self.assertIsNotNone(re.search(r'\s+hate\s+', 'I hAte you.', re.IGNORECASE))

    def test_flag_dot(self):
        self.assertIsNotNone(re.match(r'a.*b', 'a\rb'))
        self.assertIsNone(re.match(r'a.*b', 'a\nb'), 'Dot matches any character except newline in the default mode')
        self.assertIsNotNone(re.match(r'a.*b', 'a\r\nb', re.DOTALL))

    def test_flag_ascii(self):
        self.assertRegex('我们', re.compile('\w'))
        self.assertNotRegex('我们', re.compile('\w', re.ASCII))

    @unittest.skip('TODO python locale vs unicode')
    def test_flag_locale(self):
        self.assertRegex('我们', re.compile('\w', re.LOCALE))

    @unittest.skip('see test_meta_character_begin and test_meta_character_end')
    def test_flag_newline(self):
        pass

    def test_group_and_capture(self):
        matched = re.match(r'((a)b)*', 'abababc')
        self.assertEqual(matched.group(), 'ababab', 'group 0 is always the entire matached string')
        self.assertEqual(matched.group(1), 'ab', 'sub group sequence is from left to right')
        self.assertEqual(matched.group(2), 'a')

        self.assertEqual(matched.groups(),
                         ('ab', 'a'),
                         'groups return all sub string from 1 to how many three are')
        self.assertEqual(matched.group(0, 1, 2, 1),
                         ('ababab', 'ab', 'a', 'ab'),
                         'group can return any string you would like')

        matched = re.search(r'(\b\w+)\s+\1', 'Paris in the the spring')
        self.assertEqual(matched.group(), 'the the', 'You can reference capture in the pattern')

if __name__ == '__main__':
    unittest.main(verbosity=2)
