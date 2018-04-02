from django.test import TestCase
from django.urls import resolve

from lists.views import home_page
from lists.models import Item


class HomePageTest(TestCase):

    def test_uses_home_template(self):
        response = self.client.get('/')
        self.assertTemplateUsed(response, 'home.html')


class NewListTest(TestCase):
    def test_can_save_POST_request(self):
        response = self.client.post('/lists/new', data={'item_text': 'A new item'})

        self.assertEqual(Item.objects.count(), 1)
        new_item = Item.objects.first()
        self.assertEqual(new_item.text, 'A new item')

    def test_can_redirect_after_POST(self):
        response = self.client.post('/lists/new', data={'item_text': 'A new item'})

        self.assertRedirects(response, '/lists/unique-url-in-the-world/')


class ListViewTest(TestCase):

    def test_uses_list_template(self):
        response = self.client.get('/lists/unique-url-in-the-world/')
        self.assertTemplateUsed(response, 'list.html')

    def test_display_all_list_items(self):
        Item.objects.create(text='item 1')
        Item.objects.create(text='item 2')

        response = self.client.get('/lists/unique-url-in-the-world/')
        self.assertContains(response, 'item 1')
        self.assertContains(response, 'item 2')


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
