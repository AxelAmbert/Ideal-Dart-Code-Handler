import 'dart:convert';
import 'dart:io';
import 'dart:async' as async;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'MiscFunctions.dart';
import 'Visitors/ResolvedClassVisitor.dart';
import 'Visitors/ResolvedFunctionVisitor.dart';
import 'Visitors/TopLevelVariableVisitor.dart';





/*
TODO make it works by giving a path as a param
 +
 adding a param FIND_FLUTTER_PATH
 */

class Index {

  var flutterPath = '';
  var file = {};
  final funcs = [];
  final classes = [];
  final variables = [];
  var theClasses = {};
  var inheritanceTree = {};
  var programArgs = {};
  final programData = {};
  final userPath;
  var randomName;

  Index(this.userPath, List<dynamic> arguments, Function onEnd) {
    randomName = generateRandomName();
    createOutputFolder();
    index(arguments, onEnd);
  }



  void createOutputFolder() {
    createDirectory(userPath, randomName);
  }

  void handleVisit(CompilationUnit unit, String path) {
    /* if (path.startsWith(flutterPath) &&
      programArgs['deepFlutterAnalysis'] == false) {
    unit.visitChildren(UnresolvedClassVisitor());
  } else {*/
    unit.visitChildren(ResolvedClassVisitor(path, classes, programData));
    unit.visitChildren(ResolvedFunctionVisitor(path, funcs));
    unit.visitChildren(TopLevelVariableVisitor(variables));
    //}
  }

  Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
    ResolvedUnitResult placeholder;

    /* if (path.startsWith(flutterPath) &&
      programArgs['deepFlutterAnalysis'] == false) {
    return (session.getParsedUnit(path).unit);
  } else {*/
    placeholder = await session.getResolvedUnit(path);
    return (placeholder.unit);
    //}
  }

  async.Future analyzeSingleFile(AnalysisContext context, String path) async {
    AnalysisSession session = context.currentSession;
    CompilationUnit unit = await getUnit(path, session);

    handleVisit(unit, path);
  }

  async.Future analyzeAllFiles(AnalysisContextCollection collection) async {
    for (AnalysisContext context in collection.contexts) {
      for (String path in context.contextRoot.analyzedFiles()) {
        print('Analyzing ${path}');
        if (path.endsWith(".dart") == false) {
          continue;
        }
        await analyzeSingleFile(context, path);
        print('End of the analyzis of ${path}');
      }
    }
  }



  void writeEverything() {
    final fullPath = userPath + Platform.pathSeparator + randomName + Platform.pathSeparator;

    File(fullPath +  'classes.json').writeAsString(jsonEncode(theClasses));

    File(fullPath + 'inheritance.json').writeAsString(jsonEncode(inheritanceTree));

    file = {'funcs': funcs, 'classes': classes, 'constValues': variables};
    File(fullPath + 'data.json').writeAsString(jsonEncode(file));
  }

  String getFlutterPath() {
    final env = Platform.environment['PATH']?.split(';') ?? [];
    final realPath = Platform.pathSeparator +
        'packages' +
        Platform.pathSeparator +
        'flutter' +
        Platform.pathSeparator +
        'lib';
    var flutterPath = '';

    if (env.isEmpty) {
      return 'not found';
    }

    env.forEach((element) {
      if (element.contains('flutter' + Platform.pathSeparator + 'bin')) {
        flutterPath =
            element.replaceFirst(Platform.pathSeparator + 'bin', realPath);
      }
    });
    return (flutterPath);
  }


  String handlePath(String path) {
    if (path == "FLUTTER_PATH") {
      return (flutterPath);
    }
    return (path);
  }

  Map<String, dynamic> handleProgramArguments(List<dynamic> arguments) {
    var args = <String, dynamic>{};
    List<String> tmp;

    args['path'] = handlePath(arguments[0]);
    tmp = arguments[0].split('\\');
    tmp.removeAt(tmp.length - 1);
    programData['uselessPath'] = tmp.reduce((value, element) => value + '\\' + element) + '\\';

    if (arguments.contains('verbose')) {
      print('Verbose mode enabled');
      args['verbose'] = true;
    } else {
      args['verbose'] = false;
    }
    return (args);
  }



  void index(List<dynamic> arguments, Function onEnd) async {
    print("LETS GO");
    var includedPaths = <String>[];
    var collection;

    programArgs = handleProgramArguments(arguments);
    programData['flutterPath'] = getFlutterPath();
    //includedPaths.add(flutterPath);
    includedPaths.add(programArgs['path']);
    collection = AnalysisContextCollection(includedPaths: includedPaths);

    await analyzeAllFiles(collection);
    inheritanceTreeReconstruction(theClasses);
    writeEverything();
    //onEnd();
    print("END");

  }
}

/*void main(List<String> arguments) {
  Index(arguments, () {});
}*/

/*
void main(List<String> arguments, Function onEnd) async {
  var includedPaths = <String>[];
  var collection;

  programArgs = handleProgramArguments(arguments);
//  flutterPath = getFlutterPath();
  //includedPaths.add(flutterPath);
  includedPaths.add(programArgs[
      'path']); //r'C:\Users\ImPar\OneDrive\Documents\codelink-dart-indexer\lib\testdir');
  collection = AnalysisContextCollection(includedPaths: includedPaths);

  await analyzeAllFiles(collection);
  inheritanceTreeReconstruction();
  printEverything();
  //onEnd();
}*/


