
#ifndef TEST_HEADER_H
#define TEST_HEADER_H

// If unit testing is enabled override assert with mock_assert().
#ifdef UNIT_TESTING

extern void mock_assert(const int result, const char* const expression, 
                        const char * const file, const int line);
#undef assert
#define assert(expression) \
    mock_assert((int)(expression), #expression, __FILE__, __LINE__);

#endif // UNIT_TESTING

#endif // TEST_HEADER_H
