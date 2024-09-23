# Caveats

Неочевидные проблемы, с которыми пришлось столкнуться

- для линковки .a файлов их нужно ОБЯЗАТЕЛЬНО прописывать в .podscpec (s.vendored_libraries)
- (?) ./ios папка НЕ ДОЛЖНА содержать каких-то лишних файлов (например README.md или .gitignore). Если добавить, то ломается линковка .a файлов
- для подключения .a файла из .swift используются *-Bridging-Header.h файлы. Их нужно ОБЯЗАТЕЛЬНО прописывать в .podspec файле (s.preserve_path)
- для подключения ExpoModulesCore зависимостей, нужно обязательно прописывать их в .podspec файле (s.dependency)
- если .a файл собран на x86 процессоре (intel), то не получится запустить симулятор iOS на маке, запущенном на arm процессоре (apple silicon, e.g. m1)
- expo и .gitignore: eas build игнорирует файлы из всех .gitignore (https://docs.expo.dev/build-reference/easignore/)
- - неочевидная проблема #1: такое поведение распространяется ДАЖЕ на eas build --local
- - неочевидная проблема #2: .easignore, созданный рядом с .gitignore в дочерних директориях - ни на что не влияет, надо всё настраивать в корневой директории (https://github.com/expo/expo/blob/07d561b42396fd95452417899e775b993a384181/packages/expo-doctor/src/utils/files.ts#L40)