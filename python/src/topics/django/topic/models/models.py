from django.db import models

class CommonOptionalNull(models.Model):
    field_null = models.IntegerField(null=True)
    field_not_null = models.IntegerField(null=False) # the default value

