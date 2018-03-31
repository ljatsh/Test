
import unittest
import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

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

        # I was invited to enter a new to-do item
        text_box = self.browser.find_element_by_id('id_new_item')
        self.assertEqual(text_box.get_attribute('placeholder'), 'Enter a to-do item')

        # I wrote 'call my brother today'
        text_box.send_keys('call my brother today')

        # The page updated after I hit enter. And now the page lists:
        # "1. call my brother today" as an item in the to-do list
        text_box.send_keys(Keys.Enter)
        time.sleep(1)

        to_do_table = self.browser.find_element_by_id('id_to_do_list')
        rows = to_do_table.find_element_by_tag_name('tr')
        self.assertTrue(any(row.text == '1. call my brother today' for row in rows))

        # There was still an text box inviting me to enter another to-do item. I entered 'write today's diary'
        self.fail('Finished')

        # The page updated again, and now both items were shown on the lists

        # I noticed the site had generated a unique URL for me -- there was some explanatory text to that effect.

        # I visited that URL and checked my to-do list was still there

        # exit


if __name__ == '__main__':
    unittest.main(warnings='ignore')
