from django.test import TestCase
from django.db.utils import IntegrityError
from django.db.utils import DataError

import datetime

from models.models import CommonOptionNull
from models.models import CommonOptionBlank
from models.models import CommonOptionDefault
from models.models import CommonOptionChoice
from models.models import CommonOptionIndex
from models.models import CommonOptionUnique
from models.models import IntegerFileds
from models.models import FloatFields
from models.models import StringFields
from models.models import BooleanFields
from models.models import BinaryFields
from models.models import TimeFields

# TODO:
# avoid using null on string-based filed, such as CharField and TextField
# db_tablespace

#   name        default             db-constraint            form-constraint       Python-constraint
#   null         False                  Yes                      TODO                   No
#   blank        False                  No                       Yes                    No
#   default      False                  No                       No                     Yes
#   choice       False                  No                       Yes                    No
#   db_index     False                  Yes                      No                     No
#   unique       False                  Yes                      No                     No

# 1. Always add default value to filed unless the column can be actually NULL.
#    Default setting avoids init value diversity confusion.
#    It seems default value only takes effect in Python, not in db-constraint
# 2. Any value can be assigned to object filed in Python environment. Value validation and db-constraint check always
#    happen during saving period.
# 3. Choice optional is only form-constraint only.


class OptionalTest(TestCase):
    """
    Reference: https://docs.djangoproject.com/en/1.11/ref/models/fields
    """

    def test_common_option_null(self):
        obj1 = CommonOptionNull(field_not_null=10)
        obj1.save()

        obj2 = CommonOptionNull()
        self.assertIsNone(obj2.field_null)
        self.assertIsNone(obj2.field_not_null, 'null=False constraint does not take effect in python env')

        ## failure commit was the last statement. Otherwise, error occurs:
        ## "An error occurred in the current transaction. You can't "
        ## django.db.transaction.TransactionManagementError:
        ## An error occurred in the current transaction. You can't execute queries until the end of the 'atomic' block.
        ## TODO: transaction
        self.assertRaises(IntegrityError, obj2.save, 'integrity error')

    def test_common_option_blank(self):

        obj = CommonOptionBlank(field_blank='', field_not_blank='')
        obj.save()

        self.assertEquals(obj.field_not_blank, '', 'blank is not db-constraint')

    def test_common_option_default(self):
        obj = CommonOptionDefault()

        self.assertEqual(obj.field_integer, 5)
        self.assertEqual(obj.field_char, 'unknown')

    def test_common_option_choice(self):
        """
        choice is form-constraint only
        """
        obj1 = CommonOptionChoice.objects.create()
        self.assertEqual(obj1.get_field_choice_display(), 'Male')
        obj2 = CommonOptionChoice.objects.create(field_choice='f')
        self.assertEqual(obj2.get_field_choice_display(), 'Female')
        obj3 = CommonOptionChoice.objects.create(field_choice='o')
        self.assertEqual(obj3.get_field_choice_display(), 'o',
                         'display is the same as short name if short name missing from the choices')

    def test_common_option_index(self):
        obj1 = CommonOptionIndex.objects.create(field_index='role 1')
        obj2 = CommonOptionIndex.objects.create(field_index='role 2')
        # index does not mean unique
        obj3 = CommonOptionIndex.objects.create(field_index='role 1')

    def test_common_option_unique(self):
        obj1 = CommonOptionUnique.objects.create(field_unique='role 1')
        obj2 = CommonOptionUnique.objects.create(field_unique='role 2')
        # unique is db-constraint
        obj3 = CommonOptionUnique(field_unique='role 1')

        self.assertRaises(IntegrityError, CommonOptionUnique.objects.create, field_unique='role 1')


class FieldTest(TestCase):

    def test_integer_fields(self):
        """
        Minimum/Maximnum has meaning on mysql, not sqlite.
        Omit SmallIntegerField, BigIntegerField, PositiveSmallIntegerField, PositiveIntegerField
        """
        obj = IntegerFileds(field_integer=10)
        # 0x7fffffff is the maximum integer value on mysql
        obj.field_integer = 0x7fffffff
        obj.save()

        obj.field_integer += 1
        self.assertRaises(DataError, obj.save, 'data constraint error on mysql')

    def test_float_fields(self):
        obj = FloatFields(field_float=1.5)
        self.assertEqual(obj.field_float, 1.5)

    def test_string_fields(self)    :
        obj = StringFields(field_char='123456')

        self.assertEqual(obj.field_char, '123456', 'max_length is db-constraint only')
        self.assertIsNone(obj.field_text)

        self.assertRaises(DataError, obj.save, 'data constraint error on mysql')

    def test_boolean_fields(self):
        obj = BooleanFields.objects.create()
        self.assertFalse(obj.field_boolean)
        self.assertIsNone(obj.field_null_boolean)

    def test_binary_fields(self):
        obj = BinaryFields(field_binary=b'hello')
        self.assertEqual(obj.field_binary, b'hello')
        obj.field_binary = 'hello'
        self.assertEqual(obj.field_binary, 'hello', 'mismatched value type assignment is valid in Python')
        self.assertRaises(TypeError, obj.save, 'type validation and db-constraint always occurrs during saving')

    def test_time_fields(self):
        obj = TimeFields()
        self.assertIsNone(obj.field_date)
        self.assertIsNone(obj.field_datetime)
        self.assertIsNone(obj.field_time)

        obj.save()
        self.assertEqual(obj.field_date, datetime.date.today())
        self.assertEqual(obj.field_datetime.date(), datetime.date.today())
