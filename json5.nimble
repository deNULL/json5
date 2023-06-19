# Package

version       = "0.1.0"
author        = "Denis Olshin"
description   = "JSON & JSON5 implementation"
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.20.0"

task test, "Run tests":
  exec "nim c -d:json5InternalTesting -r tests/testrunner.nim"
  rmFile "tests/testrunner"

task unicode, "Generate Unicode ranges":
  exec "nim c -r unicode_data/generate '" &
    thisDir() & "/src/json5/private/generated/unicode_data.nim'"
  rmFile "unicode_data/generate"

task docs, "Generate docs":
  exec "nim doc -o:docs/json5.html src/json5"
  exec "nim doc -o:docs/pragmas.html src/json5/pragmas"
  exec "nim doc -o:docs/errors.html src/json5/errors"