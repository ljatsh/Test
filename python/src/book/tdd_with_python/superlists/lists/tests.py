from django.test import TestCase
from django.urls import resolve
from django.http import HttpRequest
from lists.views import home_page

class SmokeTest(TestCase):

    def test_root_url_resolves_to_home_page_view(self):
        found = resolve('/')
        self.assertEqual(found.func, home_page)

    def test_home_page_content(self):
        request = HttpRequest()
        response = home_page(request)
        content = response.content.decode()
        self.assertTrue(content.startswith('<html>'))
        self.assertIn('<title>TO-DO lists</title>', content)
        self.assertTrue(content.endswith('</html>'))
