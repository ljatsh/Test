#include <stdarg.h>
#include <stddef.h>
#include <setjmp.h>
#include <string.h>
#include <malloc.h>
#include <cmocka.h>
#include "header.h"

void increment_value(int * const value) {
  assert(value != NULL);
  (*value) ++;
}

void decrement_value(int * value) {
  if (value) {
    *value --;
  }
}

static const char* status_code_strings[] = {
  "Address not found",
  "Connection dropped",
  "Connection timed out",
};

const char* get_status_code_string(const unsigned int status_code) {
  return status_code_strings[status_code];
};

unsigned int string_to_status_code(const char* const status_code_string) {
  unsigned int i;
  for (i = 0; i < sizeof(status_code_strings) /
                  sizeof(status_code_strings[0]); i++) {
    if (strcmp(status_code_strings[i], status_code_string) == 0) {
      return i;
    }
  }
  return ~0U;
}

void leak_memory() {
  int * const temporary = (int*)malloc(sizeof(int));
  *temporary = 0;
}

void buffer_overflow() {
  char * const memory = (char*)malloc(sizeof(int));
  memory[sizeof(int)] = '!';
  free(memory);
}

void buffer_underflow() {
  char * const memory = (char*)malloc(sizeof(int));
  memory[-1] = '!';
  free(memory);
}

// A test case that does nothing and succeeds.
void null_test_success(void **state) {
}

/* This test case will fail but the assert is caught by run_tests() and the
 * next test is executed. */
void increment_value_fail(void **state) {
  increment_value(NULL);
}

// This test case succeeds since increment_value() asserts on the NULL pointer.
void increment_value_assert(void **state) {
  expect_assert_failure(increment_value(NULL));
}

/* This test case fails since decrement_value() doesn't assert on a NULL
 * pointer. */
void decrement_value_fail(void **state) {
  expect_assert_failure(decrement_value(NULL));
}

/* This test will fail since the string returned by get_status_code_string(0)
 * doesn't match "Connection timed out". */
void get_status_code_string_test(void **state) {
  assert_string_equal(get_status_code_string(0), "Address not found");
  assert_string_equal(get_status_code_string(1), "Connection timed out");
}

// This test will fail since the status code of "Connection timed out" isn't 1
void string_to_status_code_test(void **state) {
  assert_int_equal(string_to_status_code("Address not found"), 0);
  assert_int_equal(string_to_status_code("Connection timed out"), 1);
}

// Test case that fails as leak_memory() leaks a dynamically allocated block.
void leak_memory_test(void **state) {
  leak_memory();
}

// Test case that fails as buffer_overflow() corrupts an allocated block.
void buffer_overflow_test(void **state) {
  buffer_overflow();
}

// Test case that fails as buffer_underflow() corrupts an allocated block.
void buffer_underflow_test(void **state) {
  buffer_underflow();
}

void cmocka_test(const struct CMUnitTest* *test, int *size) {
  static const struct CMUnitTest tests[] = {
    cmocka_unit_test(null_test_success),
    // cmocka_unit_test(increment_value_fail),
    //cmocka_unit_test(increment_value_assert),
    // cmocka_unit_test(decrement_value_fail),
    // cmocka_unit_test(get_status_code_string_test),
    // cmocka_unit_test(string_to_status_code_test),
    // cmocka_unit_test(leak_memory_test),
    // cmocka_unit_test(buffer_overflow_test),
    // cmocka_unit_test(buffer_underflow_test),
  };

  *test = tests;
  *size = sizeof(tests) / sizeof(struct CMUnitTest);
}
