## Start the project by compiling it:
dart compile exe CodeLinkAnalyzer.dart [absolute_path_to_dir]

codelinkanalyzer.exe
## Or by using the Dart VM:
dart CodeLinkAnalyzer.dart [absolute_path_to_dir]

## Supported program parameters:
The path parameter is positional, and must be the first parameter, ex: "C:\Users\You\Code\lib"

The verbose parameter enable the debug output of the program

The deep parameter enable the indexing of the flutter SDK

## Example with every parameter:
dart CodeLinkAnalyzer.dart "C:\Users\You\Code\lib" deep verbose

