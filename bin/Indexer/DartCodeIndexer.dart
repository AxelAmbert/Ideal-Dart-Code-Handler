import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:async' as async;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'JsonData/IndexerParameters.dart';
import 'MiscFunctions.dart';
import 'Visitors/ResolvedClassVisitor.dart';
import 'Visitors/ResolvedFunctionVisitor.dart';
import 'Visitors/TopLevelVariableVisitor.dart';





/*
TODO make it works by giving a path as a param
 +
 adding a param FIND_FLUTTER_PATH
 */

class DartCodeIndexer {

  var flutterPath = '';
  var file = {};
  final funcs = [];
  final classes = [];
  final variables = [];
  var theClasses = {};
  var inheritanceTree = {};
  IndexerParameters programArgs;
  var randomName;




  // Verify, if it is going to index Flutter's SDK sources
  // Don't index it if the current version did not change
  bool verifyFlutterIndexing() {
    final version = File(programArgs.flutterRoot + Platform.pathSeparator + 'version').readAsStringSync();

    if (programArgs.force) {
      return true;
    }

  }

  DartCodeIndexer(this.programArgs, Function onEnd) {
    randomName = generateRandomName();
    //createOutputFolder();
    index(onEnd);
  }



  void createOutputFolder() {
    createDirectory(programArgs.finalPath, randomName);
  }

  void handleVisit(CompilationUnit unit, String path) {
    /* if (path.startsWith(flutterPath) &&
      programArgs['deepFlutterAnalysis'] == false) {
    unit.visitChildren(UnresolvedClassVisitor());
  } else {*/
    unit.visitChildren(ResolvedClassVisitor(path, classes, programArgs));
    unit.visitChildren(ResolvedFunctionVisitor(path, funcs, programArgs));
    unit.visitChildren(TopLevelVariableVisitor(variables));
    //}
  }

  Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
    ResolvedUnitResult placeholder;

    /* if (path.startsWith(flutterPath) &&
      programArgs['deepFlutterAnalysis'] == false) {
    return (session.getParsedUnit(path).unit);
  } else {*/
    placeholder = (await session.getResolvedUnit(path)) as ResolvedUnitResult;
    return (placeholder.unit);
    //}
  }

  async.Future analyzeSingleFile(AnalysisContext context, String path) async {
    AnalysisSession session = context.currentSession;
    var unit = await getUnit(path, session);

    handleVisit(unit, path);
  }

  async.Future analyzeAllFiles(AnalysisContextCollection collection) async {
    for (AnalysisContext context in collection.contexts) {
      for (String path in context.contextRoot.analyzedFiles()) {
        print('Analyzing ${path}');
        if (path.endsWith('.dart') == false) {
          continue;
        }
        await analyzeSingleFile(context, path);
        print('End of the analyzis of ${path}');
      }
    }
  }



  void writeEverything() {
    final fullPath = programArgs.finalPath + (programArgs.finalPath.endsWith(Platform.pathSeparator) ? '' : Platform.pathSeparator);

    File(fullPath + 'classes.json').createSync(recursive: true);
    File(fullPath + 'classes.json').writeAsString(jsonEncode(theClasses));

    File(fullPath + 'inheritance.json').writeAsString(jsonEncode(inheritanceTree));

    file = {'funcs': funcs, 'classes': classes, 'constValues': variables};
    File(fullPath + 'data.json').writeAsString(jsonEncode(file));
  }



  void index(Function onEnd) async {
    var collection;

    collection = AnalysisContextCollection(includedPaths: [programArgs.pathToIndex]);
    await analyzeAllFiles(collection);
    inheritanceTreeReconstruction(theClasses);
    writeEverything();
    //onEnd();

  }
}
/*
void main(List<String> arguments) {
  DartCodeIndexer(arguments, () {});
}*/
