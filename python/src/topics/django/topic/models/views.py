from django.shortcuts import render
from django.http import HttpResponse

from models.models import StringFields

# Create your views here.

def home(request):
    StringFields.objects.create(field_char='123', field_text='test')
    return HttpResponse('hello')
