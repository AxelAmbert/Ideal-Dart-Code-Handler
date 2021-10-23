import 'dart:io';

class IndexerParameters {

  //MUST BE GIVEN TO THE PROGRAM: The path that the indexer shall look for
  String pathToIndex = '';
  //MUST BE GIVEN TO THE PROGRAM: The path that the index shall write the files in
  String finalPath = '';
  //MUST BE GIVEN TO THE PROGRAM: The parameter to know if the program will print debug or not, true = debug, false = no debug
  bool verbose = true;
  //MUST BE GIVEN TO THE PROGRAM: The parameter to know if the program has to verify Flutter's version to analyze Flutter's SDK
  bool force = false;
  //FOUND BY THE PROGRAM: The flutter path that was found by the Indexer
  String flutterLibPath = '';
  //FOUND BY THE PROGRAM: The pathToIndex, with a path separator at the end of it
  String uselessPath = '';

  String flutterRoot = '';

  void getFlutterPath() {
    final env = Platform.environment['PATH'].split(';') ?? [];
    final realPath = Platform.pathSeparator +
        'packages' +
        Platform.pathSeparator +
        'flutter' +
        Platform.pathSeparator +
        'lib';

    if (env.isEmpty) {
      return;
    }

    env.forEach((element) {
      if (element.contains('flutter' + Platform.pathSeparator + 'bin')) {
        final toRemove = Platform.pathSeparator + 'bin';

        flutterLibPath = element.replaceFirst(toRemove, realPath);
        flutterRoot = element.replaceFirst(toRemove, '');
      }
    });
  }

  String handlePath(String path) {
    if (path == 'FLUTTER_PATH') {
      return (flutterLibPath);
    }
    return (path);
  }

  void handleIndexerParameters(dynamic parameters) {
    List<String> tmp;

    pathToIndex = handlePath(parameters['pathToIndex']);
    /*tmp = parameters['pathToIndex'].split(Platform.pathSeparator);
    print(tmp);
    tmp.removeAt(tmp.length - 1);
    uselessPath = tmp.reduce((value, element) => value + Platform.pathSeparator + element) + Platform.pathSeparator;*/
    uselessPath = parameters['pathToIndex'];
    verbose = parameters['verbose'];
    finalPath = parameters['finalPath'];
    force = parameters['force'];
    getFlutterPath();
  }

  IndexerParameters(dynamic parameters) {
    handleIndexerParameters(parameters);
  }

}