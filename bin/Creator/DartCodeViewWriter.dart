import 'dart:convert';
import 'dart:io';
import 'dart:async' as async;
import 'package:path/path.dart' as path;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'CodeWriter/DeclarationWriter.dart';
import 'CodeWriter/ImportWriter.dart';
import 'CodeWriter/MethodWriter.dart';
import 'CodeWriter/RouteWriter.dart';
import 'ConstrainedValue.dart';
import 'JsonData/CreatorData.dart';
import 'JsonData/DataToDelete.dart';
import 'JsonData/FieldDeclarationData.dart';
import 'JsonData/MethodDeclarationData.dart';
import 'JsonData/CreatorParameters.dart';
import 'Visitors/ImportDirectiveVisitor.dart';
import 'Visitors/ResolvedClassVisitor.dart';
import 'ViewCreator.dart';

class DartCodeViewWriter {
  List<ConstrainedValue> constrainedValues = <ConstrainedValue>[];
  CreatorData creatorData;
  String file = '';
  int currentView = 0;
  Function onEnd;

  DartCodeViewWriter(this.creatorData, this.onEnd);

  void addImports(dynamic imports) {}

  void handleVisit(CompilationUnit unit, String path) {
    //TODO add classToLookFor to select only the right class.
    unit.visitChildren(ImportDirectiveVisitor(constrainedValues));
    unit.visitChildren(
        ResolvedClassVisitor(constrainedValues, creatorData.view));
  }

  Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
    ResolvedUnitResult placeholder;

    placeholder = (await session.getResolvedUnit(path)) as ResolvedUnitResult;
    return (placeholder.unit);
  }

  async.Future analyzeSingleFile(AnalysisContext context, String path) async {
    AnalysisSession session = context.currentSession;
    var unit = await getUnit(path, session);

    handleVisit(unit, path);
  }

  async.Future analyzeAllFiles(AnalysisContextCollection collection) async {
    for (AnalysisContext context in collection.contexts) {
      for (String path in context.contextRoot.analyzedFiles()) {
        if (path.endsWith('.dart') == false) {
          continue;
        }
        await analyzeSingleFile(context, path);
      }
    }
  }

  String reconstructViewPath() {
    return creatorData.path +
        Platform.pathSeparator +
        'lib' +
        Platform.pathSeparator +
        creatorData.view +
        '.dart';
  }

  void getFileString() {
    file = File(reconstructViewPath()).readAsStringSync();
  }

  DataToDelete getDataToDelete() {
    final fullPath = path.join(creatorData.path, '.ideal_project', 'handler',
        'creator', creatorData.view + '_mem_del.json');
    var jsonFile;
    var jsonData;

    File(fullPath).createSync(recursive: true);
    jsonFile = File(fullPath).readAsStringSync();

    try {
      jsonData = jsonDecode(jsonFile);
      return DataToDelete(jsonData);
    } catch (e, s) {
      return DataToDelete.empty();
    }
  }

  List<String> executeImportWriter(
      List<String> importList, DataToDelete dataToDelete) {
    final importWriter = ImportWriter(file);

    importWriter.removeFromFile(dataToDelete.imports, constrainedValues);
    importWriter.addToFile(importList, constrainedValues);
    file = importWriter.file;
    return importWriter.addedData;
  }

  List<String> executeDeclarationWriter(
      List<FieldDeclarationData> fieldList, DataToDelete dataToDelete) {
    final declarationWriter = DeclarationWriter(file);

    declarationWriter.removeFromFile(
        dataToDelete.declarations, constrainedValues);
    declarationWriter.addToFile(fieldList, constrainedValues);
    file = declarationWriter.file;
    return declarationWriter.addedData;
  }

  List<String> executeMethodWriter(
      List<MethodDeclarationData> methodList, DataToDelete dataToDelete) {
    final methodWriter = MethodWriter(file);

    methodWriter.removeFromFile(dataToDelete.methods, constrainedValues);
    methodWriter.addToFile(methodList, constrainedValues);
    file = methodWriter.file;
    return methodWriter.addedData;
  }

  String executeEveryWriter(String file, DataToDelete dataToDelete) {
    final imports = executeImportWriter(creatorData.imports, dataToDelete);
    final declarations =
        executeDeclarationWriter(creatorData.fieldDeclarations, dataToDelete);
    final methods = executeMethodWriter(creatorData.methodDeclarations, dataToDelete);

    return (json.encode({
      'imports': imports,
      'methods': methods,
      'declarations': declarations
    }));
  }

  void writeCode(DataToDelete dataToDelete) {
    final pathToCode =
        path.join(creatorData.path, 'lib', creatorData.view + '.dart');
    final pathToCreatedData = path.join(creatorData.path, '.ideal_project',
        'handler', 'creator', creatorData.view + '_mem_del.json');
    final newDataToDelete = executeEveryWriter(file, dataToDelete);
    File(pathToCreatedData).writeAsStringSync(newDataToDelete);
    File(pathToCode).writeAsStringSync(file);
  }

  void createMainAndView() {
    final viewPath =
        path.join(creatorData.path, 'lib', creatorData.view + '.dart');
    final mainPath = path.join(creatorData.path, 'lib', 'main.dart');
    final viewFile = File(viewPath);
    final mainFile = File(mainPath);

    if (viewFile.existsSync() == false) {
      viewFile.writeAsStringSync(ViewCreator.createView(creatorData.view));
    }
    if (mainFile.existsSync() == false) {
      mainFile.writeAsStringSync(ViewCreator.createMain());
    }
  }

  void createMissingFiles() {
    createMainAndView();
    //RouteWriter.write(creatorData);
  }

  Future<void> creator() async {
    print('INDEXER DEBUG MODE ACTIVATED');
    final dataToDelete = getDataToDelete();
    final collection = AnalysisContextCollection(
        includedPaths: [reconstructViewPath()]);

    createMissingFiles();
    await analyzeAllFiles(collection);
    getFileString();
    writeCode(dataToDelete);
  }
}
/*
void main(List<String> arguments) async {
  final file = File('args.json').readAsStringSync();
  dynamic json = jsonDecode(file);


  await DartCodeCreator(CreatorParameters(json), () {});
}
*/
