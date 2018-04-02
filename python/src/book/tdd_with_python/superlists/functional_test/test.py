
import unittest
import time

from django.test import LiveServerTestCase

from selenium import webdriver
from selenium.webdriver.common.keys import Keys


class FunctionalTest(LiveServerTestCase):
    def setUp(self):
        self.browser = webdriver.Firefox()

    def tearDown(self):
        self.browser.quit()

    def check_row_in_list_table(self, row_text):
        to_do_table = self.browser.find_element_by_id('id_to_do_list')
        rows = to_do_table.find_elements_by_tag_name('tr')
        self.assertIn(row_text, [row.text for row in rows],
                      f'New to-do item does not appear. Contents were:\n{to_do_table.text}')

    def test_can_start_a_list_and_retrieve_it_later(self):
        # I heard about a cool new online to-do app and then, went to check its home page.
        self.browser.get(self.live_server_url)

        # I noticed its title contains 'TO-DO'
        self.assertIn('TO-DO', self.browser.title)

        # I was invited to enter a new to-do item
        text_box = self.browser.find_element_by_id('id_new_item')
        self.assertEqual(text_box.get_attribute('placeholder'), 'Enter a to-do item')

        # I wrote 'call my brother today'
        text_box.send_keys('call my brother today')

        # The page updated after I hit enter. And now the page lists:
        # "1. call my brother today" as an item in the to-do list
        text_box.send_keys(Keys.ENTER)
        time.sleep(1)

        self.check_row_in_list_table('1. call my brother today')

        # There was still an text box inviting me to enter another to-do item. I entered 'write today's diary'
        # The DOM has been updated, so we need to pickup relevant elements again.
        text_box = self.browser.find_element_by_id('id_new_item')
        text_box.send_keys('write today\'s diary')
        text_box.send_keys(Keys.ENTER)
        time.sleep(1)

        # The page updated again, and now both items were shown on the lists
        self.check_row_in_list_table('1. call my brother today')
        self.check_row_in_list_table('2. write today\'s diary')

    def test_multiple_user_can_start_lists_with_different_urls(self):
        # I created 2 to-do items
        self.browser.get(self.live_server_url)

        text_box = self.browser.find_element_by_id('id_new_item')
        text_box.send_keys('call my brother today')
        text_box.send_keys(Keys.ENTER)
        time.sleep(1)

        self.check_row_in_list_table('1. call my brother today')

        my_url = self.browser.current_url
        self.assertRegex(my_url, '/lists/.+')

        # Another user visit the same url, he should not see my to-do lists

        ## close the browser firstly to clear cookie
        self.browser.quit()
        self.browser = webdriver.Firefox()

        print(self.live_server_url)
        self.browser.get(self.live_server_url)

        page_text = self.browser.find_element_by_tag_name('body').text
        self.assertNotIn('1. call my brother today', page_text)

        text_box = self.browser.find_element_by_id('id_new_item')
        text_box.send_keys('purchase milk')
        text_box.send_keys(Keys.ENTER)
        time.sleep(1)

        self.check_row_in_list_table('1. purchase milk')

        their_url = self.browser.current_url()
        self.assertRegEx(their_url, 'lists/.+')

        # He cannot see my to-do lists
        page_text = self.browser.find_element_by_tag_name('body').text
        self.assertNotIn('1. call my brother today', page_text)

        self.assertNotEqual(my_url, their_url)

        self.fail('Finished')


if __name__ == '__main__':
    unittest.main(warnings='ignore')
