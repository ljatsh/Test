{
  'variables': {
  },
  'target_defaults': {
    'default_configuration': 'Debug',
    'configurations': {
      'Debug': {
        'defines': [ 'DEBUG', '_DEBUG' ],
        'cflags':  [ '-g']
      },
      'Release': {
        'defines': [ 'NDEBUG' ],
      }
    },
    'include_dirs': [],
    'cflags': [ '-Wall', '-Werror', '-O2', '-std=c99', '-fPIC']
   },

   'targets': [
    {
      'target_name': 'test',
      'product_name': 'test',
      'product_prefix': '',
      'type': 'shared_library',
      'dependencies': [],
      'sources': ['libtest.c']
    }
   ]
}