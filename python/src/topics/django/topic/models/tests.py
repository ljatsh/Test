from django.test import TestCase
from django.db.utils import IntegrityError

from models.models import CommonOptionalNull

# TODO:
# avoid using null on string-based fileds, such as CharField and TextField

# 1. All common optionas are optional: null
#
#

class FieldTest(TestCase):

    def test_common_optional_null(self):
        '''
        common optional null: https://docs.djangoproject.com/en/1.11/ref/models/fields/#null
        '''

        obj1 = CommonOptionalNull(field_not_null=10)
        obj1.save()
        self.assertEqual(CommonOptionalNull.objects.first().field_not_null, 10)

        obj2 = CommonOptionalNull()
        self.assertIsNone(obj2.field_null)
        self.assertIsNone(obj2.field_not_null, 'null=False constraint does not take effect in python env')

        ## failure commit was the last statement. Otherwise, error occurs:
        ## "An error occurred in the current transaction. You can't "
        ## django.db.transaction.TransactionManagementError:
        ## An error occurred in the current transaction. You can't execute queries until the end of the 'atomic' block.
        ## TODO: transaction
        self.assertRaises(IntegrityError, obj2.save, 'integrity error')

