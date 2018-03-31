
import unittest
from selenium import webdriver

class FunctionalTest(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def test_diango_was_setup_correctly(self):
        self.browser.get('http://localhost:8000')
        self.assertIn('Django', self.browser.title, 'default page title contains Django')


if __name__ == '__main__':
    unittest.main(warnings='ignore')
