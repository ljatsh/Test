from django.db import models


class CommonOptionNull(models.Model):
    field_null = models.IntegerField(null=True)
    field_not_null = models.IntegerField(null=False) # the default value

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class CommonOptionBlank(models.Model):
    field_blank = models.TextField(blank=True)
    field_not_blank = models.TextField()
    field_int_blank = models.IntegerField(blank=True, default=0)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class CommonOptionDefault(models.Model):
    field_integer = models.IntegerField(default=5)
    field_char = models.CharField(default='unknown', max_length=30)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class CommonOptionChoice(models.Model):
    SEX_CHOICES = (('m', 'Male'), ('f', 'Female'))
    field_choice = models.CharField(max_length=1,
                                    default='m',
                                    choices=SEX_CHOICES,
                                    db_column='sex',
                                    help_text='sex of this entry',
                                    verbose_name='the sex')

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class CommonOptionIndex(models.Model):
    field_index = models.CharField(max_length=32, db_index=True)


class CommonOptionUnique(models.Model):
    field_unique = models.CharField(max_length=32, unique=True)


class IntegerFileds(models.Model):
    field_integer = models.IntegerField()
    field_positive_small_integer = models.PositiveSmallIntegerField(default=10)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class FloatFields(models.Model):
    """
    TODO: Python Decimal and DecimalField
    """
    field_float = models.FloatField(default=0.0)
    field_decimal = models.DecimalField(default=0.12454646, max_digits=5, decimal_places=2)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class StringFields(models.Model):
    field_char = models.CharField(max_length=5)
    field_text = models.TextField(null=True)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class BooleanFields(models.Model):
    field_boolean = models.BooleanField(default=False)
    field_null_boolean = models.NullBooleanField()

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class BinaryFields(models.Model):
    field_binary = models.BinaryField()

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)


class TimeFields(models.Model):
    field_date = models.DateField(auto_now=True)
    field_datetime = models.DateTimeField(auto_now_add=True)
    field_time = models.TimeField(auto_now_add=True)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)

class ForeignKeyFields(models.Model):
    field_foreign = models.ForeignKey(StringFields, on_delete=models.CASCADE)

    def __str__(self):
        result = []
        for k, v in vars(self).items():
            result.append('{}={!r}'.format(k, v))

        return '\n'.join(result)
