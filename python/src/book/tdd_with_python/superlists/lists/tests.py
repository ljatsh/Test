from django.test import TestCase
from django.urls import resolve

from lists.views import home_page
from lists.models import Item


class HomePageTest(TestCase):

    def test_uses_home_template(self):
        response = self.client.get('/')
        self.assertTemplateUsed(response, 'home.html')

    def test_only_saves_items_when_necessary(self):
        self.client.get('/')
        self.assertEqual(Item.objects.count(), 0)

    def test_can_save_POST_request(self):
        response = self.client.post('/', data={'item_text': 'A new item'})

        self.assertEqual(Item.objects.count(), 1)
        new_item = Item.objects.first()
        self.assertEqual(new_item.text, 'A new item')

    def test_can_redicrect_after_POST(self):
        response = self.client.post('/', data={'item_text': 'A new item'})

        self.assertEqual(response.status_code, 302)
        self.assertEqual(response['location'], '/')

    def test_displays_all_list_items(self):
        Item.objects.create(text='item 1')
        Item.objects.create(text='item 2')

        response = self.client.get('/')
        self.assertIn('item 1', response.content.decode())
        self.assertIn('item 2', response.content.decode())

class ItemModelTest(TestCase):

    def test_save_and_retrieve_items(self):
        first = Item()
        first.text = 'Item_1'
        first.save()

        second = Item()
        second.text = 'Item_2'
        second.save()

        saved_items = Item.objects.all()
        self.assertEqual(saved_items.count(), 2)

        saved_first = saved_items[0]
        saved_second = saved_items[1]
        self.assertTrue(saved_first.text, 'Item_1')
        self.assertTrue(saved_second.text, 'Item_2')
