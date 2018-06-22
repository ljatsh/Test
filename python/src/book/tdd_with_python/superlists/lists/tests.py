from django.test import TestCase
from django.urls import resolve

from lists.views import home_page
from lists.models import Item, List


class HomePageTest(TestCase):

    def test_uses_home_template(self):
        response = self.client.get('/')
        self.assertTemplateUsed(response, 'home.html')


class NewItemTest(TestCase):
    def test_can_save_POST_request(self):
        response = self.client.post('/lists/new', data={'item_text': 'A new item'})

        self.assertEqual(Item.objects.count(), 1)
        new_item = Item.objects.first()
        self.assertEqual(new_item.text, 'A new item')

    def test_can_redirect_after_POST(self):
        response = self.client.post('/lists/new', data={'item_text': 'A new item'})

        list = List.objects.first()
        self.assertRedirects(response, '/lists/{}/'.format(list.id))

    def test_can_save_POST_request_to_existing_list(self):
        list1 = List.objects.create()
        list2 = List.objects.create()

        response = self.client.post('/lists/{}/add_item'.format(list2.id), data={'item_text': 'A new item'})

        self.assertEqual(Item.objects.count(), 1)
        new_item = Item.objects.first()
        self.assertEqual(new_item.text, 'A new item')
        self.assertEqual(new_item.list, list2)

    def test_redirects_to_list_view(self):
        list1 = List.objects.create()
        list2 = List.objects.create()

        response = self.client.post('/lists/{}/add_item'.format(list2.id), data={'item_text': 'A new item'})
        self.assertRedirects(response, '/lists/{}/'.format(list2.id))

class ListViewTest(TestCase):

    def test_uses_list_template(self):
        list = List.objects.create()
        response = self.client.get('/lists/{}/'.format(list.id))
        self.assertTemplateUsed(response, 'list.html')

    def test_display_only_items_for_that_list(self):
        list1 = List.objects.create()
        Item.objects.create(text='item 1', list=list1)
        Item.objects.create(text='item 2', list=list1)

        list2 = List.objects.create()
        Item.objects.create(text='item 3', list=list2)
        Item.objects.create(text='item 4', list=list2)

        response = self.client.get('/lists/{}/'.format(list1.id))
        self.assertContains(response, 'item 1')
        self.assertContains(response, 'item 2')
        self.assertNotContains(response, 'item 3')
        self.assertNotContains(response, 'item 4')

    def test_passes_correct_list_to_template(self):
        list1 = List.objects.create()
        list2 = List.objects.create()

        response = self.client.get('/lists/{}/'.format(list2.id))
        self.assertEqual(response.context['list'], list2)


class ListItemModelTest(TestCase):

    def test_save_and_retrieve_items(self):
        list = List()
        list.save()

        first = Item()
        first.text = 'Item_1'
        first.list = list
        first.save()

        second = Item()
        second.text = 'Item_2'
        second.list = list
        second.save()

        saved_list = List.objects.first()
        self.assertEqual(saved_list, list)

        saved_items = Item.objects.all()
        self.assertEqual(saved_items.count(), 2)

        saved_first = saved_items[0]
        saved_second = saved_items[1]
        self.assertTrue(saved_first.text, 'Item_1')
        self.assertTrue(saved_second.text, 'Item_2')
