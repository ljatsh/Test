
#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <malloc.h>
#include <string.h>
#include <cmocka.h>

extern void cmocka_test(const struct CMUnitTest* *test, int *size);
extern void ansic_stdarg_test(const struct CMUnitTest* *test, int *size);

typedef void (*test_protocol)(const struct CMUnitTest* *test, int *size);

int main(int argc, char* argv[]) {
  const test_protocol tests[] = {
    cmocka_test,
    ansic_stdarg_test
  };

  int size = 0;
  const struct CMUnitTest *test = NULL;
  int temp = 0;
  int i = 0;
  for (i=0; i<sizeof(tests)/sizeof(test_protocol); i++) {
    tests[i](&test, &temp);
    size += temp;
  }

  if (temp == 0)
    return 0;

  struct CMUnitTest* all_tests = (struct CMUnitTest*)malloc(sizeof(struct CMUnitTest) * size);
  struct CMUnitTest* dest = all_tests;
  for (i=0; i<sizeof(tests)/sizeof(test_protocol); i++) {
    tests[i](&test, &temp);
    memcpy(dest, test, sizeof(struct CMUnitTest) * temp);
    dest += temp;
  }

  int result = _cmocka_run_group_tests("test", all_tests, size, NULL, NULL);
  free(all_tests);

  return result;
}
