
# -*- coding: utf-8 -*-

# 1. There are 2 time representation:
#    1) elapsed seconds since epoch
#    2) coordinate universal time(UTC, aka GMT, Greenwich Mean Time), human readable representation
# 2. Conversations
#               epoch                           utc               string
# epoch          *                        gmtime,localtime         ctime
# utc        calender.timegm,mktime             *                  asctime, strftime
# string                                    strptime                *


import unittest
import time


class TestTime(unittest.TestCase):

    def test_time(self):
        localtime = time.strptime('2018-04-04 15:31:30', '%Y-%m-%d %H:%M:%S')
        self.assertEqual(localtime.tm_year, 2018)
        self.assertEqual(localtime.tm_mon, 4)
        self.assertEqual(localtime.tm_mday, 4)
        self.assertEqual(localtime.tm_hour, 15)
        self.assertEqual(localtime.tm_min, 31)
        self.assertEqual(localtime.tm_sec, 30)

        # time data '2018-04-04' does not match format '%Y-%m-%d %H:%M:%S'
        self.assertRaises(ValueError, time.strptime, '2018-04-04', '%Y-%m-%d %H:%M:%S')
        # unconverted data remains: 15:31:30
        self.assertRaises(ValueError, time.strptime, '2018-04-04 15:31:30', '%Y-%m-%d')


if __name__ == '__main__':
    unittest.main(verbosity=2)
