from django.test import TestCase
from django.urls import resolve

from lists.views import home_page
from lists.models import Item


class HomePageTest(TestCase):

    def test_uses_home_template(self):
        response = self.client.get('/')
        self.assertTemplateUsed(response, 'home.html')

    def test_can_save_POST_request(self):
        response = self.client.post('/', data={'item_text': 'A new item'})
        self.assertIn('A new item', response.content.decode())
        self.assertTemplateUsed(response, 'home.html')


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
