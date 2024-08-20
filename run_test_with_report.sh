dart run build_runner build
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html