
import unittest
import logging
import io
import time


# https://docs.python.org/3/library/logging.html
# 1. Formatter is atached to Handler, the initialized fmt string references LogRecord attributes and
#    extra,... parameters from log functions
# TODO: Logger Propogate, Configuration, Filter and Handler
class TestLogging(unittest.TestCase):
    def setUp(self):
        self.logger = logging.getLogger('test')
        self.logger.setLevel(logging.DEBUG)

        self.output = io.StringIO()
        self.stream_handler = logging.StreamHandler(self.output)
        self.logger.addHandler(self.stream_handler)

    def tearDown(self):
        self.logger.removeHandler(self.stream_handler)

    def test_logging_formatter(self):
        formatter = logging.Formatter(fmt='%(asctime)s|%(levelname)s|%(name)s|%(uid)s|%(message)s',
                                      datefmt='%Y-%m-%d %H:%M:%S')
        self.stream_handler.setFormatter(formatter)
        self.logger.info('log_message:%d', 5, extra={'uid':10001})

        values = self.output.getvalue().split('|')

        expected_now = int(time.time())
        actual_now = time.strptime(values[0], '%Y-%m-%d %H:%M:%S')
        actual_now = int(time.mktime(actual_now))
        self.assertEqual(actual_now, expected_now)

        self.assertEqual(values[1], 'INFO')
        self.assertEqual(values[2], 'test')
        self.assertEqual(values[3], '10001')
        self.assertEqual(values[4].strip(), 'log_message:5')
