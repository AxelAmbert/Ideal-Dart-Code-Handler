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

class DartCodeCreator {
  List<ConstrainedValue> constrainedValues = <ConstrainedValue>[];
  CreatorParameters parameters;
  String file = '';

  DartCodeCreator(this.parameters, Function onEnd) {
    creator(onEnd);
  }

  void addImports(dynamic imports) {}

  void handleVisit(CompilationUnit unit, String path) {
    //TODO add classToLookFor to select only the right class.
    unit.visitChildren(ImportDirectiveVisitor(constrainedValues));
    unit.visitChildren(ResolvedClassVisitor(constrainedValues, parameters.view));
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

  String reconstructViewPath(CreatorParameters parameters) {
    return parameters.path +
        Platform.pathSeparator +
        'lib' +
        Platform.pathSeparator +
        parameters.view +
        '.dart';
  }

  void getFileString() {
    file = File(reconstructViewPath(parameters)).readAsStringSync();
  }

  DataToDelete getDataToDelete() {
    final fullPath = path.join(parameters.path, '.ideal_project', 'handler', 'creator', parameters.view + '_mem_del.json');
    var jsonFile;
    var jsonData;

    File(fullPath).createSync(recursive: true);
    jsonFile = File(fullPath).readAsStringSync();

    try {
      jsonData = jsonDecode(jsonFile);
      return DataToDelete(jsonData);
    } catch (e, s) {
      print('Error while fetching data to delete');
      print(e);
      print(s);
      return DataToDelete.empty();
    }
  }

  List<String> executeImportWriter(List<String> importList, DataToDelete dataToDelete) {
    final importWriter = ImportWriter(file);


    importWriter.removeFromFile(dataToDelete.imports, constrainedValues);
    importWriter.addToFile(importList, constrainedValues);
    file = importWriter.file;
    return importWriter.addedData;
  }

  List<String> executeDeclarationWriter(List<FieldDeclarationData> fieldList, DataToDelete dataToDelete) {
    final declarationWriter = DeclarationWriter(file);

    declarationWriter.removeFromFile(dataToDelete.declarations, constrainedValues);
    declarationWriter.addToFile(fieldList, constrainedValues);
    file = declarationWriter.file;
    return declarationWriter.addedData;
  }

  List<String> executeMethodWriter(List<MethodDeclarationData> methodList, DataToDelete dataToDelete) {
    final methodWriter = MethodWriter(file);

    methodWriter.removeFromFile(dataToDelete.methods, constrainedValues);
    methodWriter.addToFile(methodList, constrainedValues);
    file = methodWriter.file;
    return methodWriter.addedData;
  }

   String executeEveryWriter(CreatorData data, String file, DataToDelete dataToDelete) {
    final imports = executeImportWriter(data.imports, dataToDelete);
    final declarations = executeDeclarationWriter(data.fieldDeclarations, dataToDelete);
    final methods = executeMethodWriter(data.methodDeclarations, dataToDelete);


    RouteWriter.write(parameters);
    return (json.encode({'imports':imports, 'methods':methods, 'declarations':declarations}));
  }

  void writeCode(DataToDelete dataToDelete) {
    final pathToCode = path.join(parameters.path, 'lib', parameters.view + '.dart');
    final pathToCreatedData = path.join(parameters.path, '.ideal_project', 'handler', 'creator', parameters.view + '_mem_del.json');
    final data = CreatorData(parameters.code);
    final newDataToDelete = executeEveryWriter(data, file, dataToDelete);

    File(pathToCreatedData).writeAsStringSync(newDataToDelete);
    File(pathToCode).writeAsStringSync(file);
  }


  void createMainAndView() {
    final viewPath = path.join(parameters.path, 'lib', parameters.view + '.dart');
    final mainPath = path.join(parameters.path, 'lib', 'IdealMain.dart');
    final viewFile = File(viewPath);
    final mainFile = File(mainPath);

    if (viewFile.existsSync() == false) {
      viewFile.writeAsStringSync(ViewCreator.createView(parameters.view));
    }
    if (mainFile.existsSync() == false) {
      mainFile.writeAsStringSync(ViewCreator.createMain());
    }
  }



  void createMissingFiles() {
    createMainAndView();
    RouteWriter.write(parameters);
  }

  void creator(Function onEnd) async {
    print('INDEXER DEBUG MODE ACTIVATED');
    final dataToDelete = getDataToDelete();
    final collection =
        AnalysisContextCollection(includedPaths: [reconstructViewPath(parameters)]);

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