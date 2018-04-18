
# -*-: utf-8 -*-

"""
Reference: http://jkorpela.fi/chars.html
           https://docs.python.org/3/howto/unicode.html

1. Character repertoire ---> Character sets. A set of distinct characters for human reading.
2. Character code ---> A mapping which defines a one-to-one correspondence between characters and a set of
   non negative integers.(aka coding point, code number)
3. Character coding ---> A method for presenting characters in digital form by mapping sequences of code points
   of characters into sequences of octets. One purpose of encoding is to save space.

4. Code point is independent with coding algorithm.
5. The most important tip for writing unicode-aware program is:
   Software should only work with unicode strings internally, decode the input as soon as possible and encode the output
   at the end.

"""

import unittest


class UnicodeTest(unittest.TestCase):

    def test_code_point(self):
        self.assertEqual('A', chr(ord('A')))

    def test_unicode_literal(self):
        self.assertEqual('\u4e2d\u534e\u4eba\u6c11\u5171\u548c\u56fd', '中华人民共和国')

    def test_encoding(self):
        b = '中华人民共和国'.encode('utf-8')
        self.assertEqual(b.decode('utf-8'), '中华人民共和国')

    def test_codecs_124(self):
        # TODO
        pass

if __name__ == '__main__':
    # print([hex(ord(c)) for c in '中华人民共和国']);
    unittest.main(verbosity=2)
