# -*- coding: utf-8 -*-
# Generated by Django 1.11 on 2018-04-03 17:03
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CommonOptionalBlank',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('field_blank', models.TextField(blank=True)),
                ('field_not_blank', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='CommonOptionalNull',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('field_null', models.IntegerField(null=True)),
                ('field_not_null', models.IntegerField()),
            ],
        ),
    ]