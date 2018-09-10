{
  'make_global_settings': [
    ['CC', '/usr/bin/clang'],
    ['CXX', '/usr/bin/clang++']
  ],

  'target_defaults': {
    'xcode_settings': {
      'GCC_OPTIMIZATION_LEVEL': '0',
      'CLANG_ENABLE_OBJC_WEAK': 'YES',

      'ALWAYS_SEARCH_USER_PATHS': 'NO',
      'GCC_CW_ASM_SYNTAX': 'NO',                # No -fasm-blocks
      'GCC_DYNAMIC_NO_PIC': 'NO',               # No -mdynamic-no-pic
                                            # (Equivalent to -fPIC)
      'GCC_ENABLE_CPP_EXCEPTIONS': 'NO',        # -fno-exceptions
      'GCC_ENABLE_CPP_RTTI': 'NO',              # -fno-rtti
      'GCC_ENABLE_PASCAL_STRINGS': 'NO',        # No -mpascal-strings
      'GCC_THREADSAFE_STATICS': 'NO',           # -fno-threadsafe-statics
      'PREBINDING': 'NO',                       # No -Wl,-prebind
      'USE_HEADERMAP': 'NO',
        'WARNING_CFLAGS': [
        '-Wall',
        '-Wendif-labels',
        '-W',
        '-Wno-unused-parameter',
        '-Wstrict-prototypes',
      ],
    }
  },

  'targets': [
    {
      'target_name' : 'tp-mac',
      'product_name' : 'tp-mac',
      'type' : 'executable',
      'mac_bundle' : 1,
      'mac_bundle_resources' : [
        'mac/Base.lproj/MainMenu.xib',
        'mac/Assets.xcassets'
      ],
      'sources': [
        'mac/AppDelegate.m',
        'mac/main.m'
      ],
      'link_settings': {
        'libraries': [
           '$(SDKROOT)/System/Library/Frameworks/AppKit.framework',
        ],
      },
      'xcode_settings': {
        'INFOPLIST_FILE': 'mac/Info.plist',
        'PRODUCT_BUNDLE_IDENTIFIER' : 'cn.gyp.tp-mac',
        'ASSETCATALOG_COMPILER_APPICON_NAME' : 'AppIcon'
      }
    }
  ]
}
