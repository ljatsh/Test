from django.db import models

class CommonOptionalNull(models.Model):
    field_null = models.IntegerField(null=True)
    field_not_null = models.IntegerField(null=False) # the default value


class CommonOptionalBlank(models.Model):
    field_blank = models.TextField(blank=True)
    field_not_blank = models.TextField()

