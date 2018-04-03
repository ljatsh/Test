from django.shortcuts import render, redirect
from django.http import HttpRequest, HttpResponse

from lists.models import Item, List


def home_page(request):
    return render(request, 'home.html')


def new_list(request):
    list = List.objects.create()
    Item.objects.create(text=request.POST['item_text'], list=list)
    return redirect('/lists/{}/'.format(list.id))


def view_list(request, list_id):
    list = List.objects.get(id=list_id)
    items = Item.objects.filter(list=list)
    return render(request, 'list.html', {'list':list, 'items': items})

def add_item(request, list_id):
    list = List.objects.get(id=list_id)
    Item.objects.create(text=request.POST['item_text'], list=list)
    return redirect('/lists/{}/'.format(list.id))
