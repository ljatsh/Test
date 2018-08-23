
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <cmocka.h>

void first_test(void* *state) {
  assert_string_equal("123", "123");
}

void ansic_stdarg_test(const struct CMUnitTest* *test, int* size) {
  static const struct CMUnitTest tests[] = {
    cmocka_unit_test(first_test),
  };

  *test = tests;
  *size = sizeof(tests) / sizeof(struct CMUnitTest);
}
