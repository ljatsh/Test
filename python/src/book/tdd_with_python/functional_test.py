
import unittest
from selenium import webdriver

class FunctionalTest(unittest.TestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def test_can_start_a_list_and_retrieve_it_later(self):
        # I heard about a cool new onlin to-do app and then, went to check its home page.
        self.browser.get('http://localhost:8000')

        # I noticed its title contains 'TO-DO'
        self.assertIn('TO-DO', self.browser.title)

        self.fail('Finished!')

        # I was invited to enter a new to-do item

        # I wrote 'call my brother today'

        # The page updated after I hit enter. And now the page lists:
        # "1. call my brother today" as an item in the to-do list

        # There was still an text box inviting me to enter another to-do item. I entered 'write today's diary'

        # The page updated again, and now both items were shown on the lists

        # I noticed the site had generated a unique URL for me -- there was some explanatory text to that effect.

        # I visited that URL and checked my to-do list was still there

        # exit


if __name__ == '__main__':
    unittest.main(warnings='ignore')
