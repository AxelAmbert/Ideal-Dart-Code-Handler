import 'dart:convert';
import 'dart:io';
import 'dart:async' as async;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';

import 'CodeWriter/ConstraintEditor.dart';
import 'CodeWriter/ImportWriter.dart';
import 'ConstrainedValue.dart';
import 'Visitors/ImportDirectiveVisitor.dart';
import 'Visitors/ResolvedClassVisitor.dart';

class DartCodeCreator {
  List<ConstrainedValue> constrainedValues = <ConstrainedValue>[];
  final classToLookFor = '';

  DartCodeCreator(List<dynamic> arguments, Function onEnd) {
    creator(arguments, onEnd);
  }

  void addImports(dynamic imports) {}

  void handleVisit(CompilationUnit unit, String path) {
    //TODO add classToLookFor to select only the right class.
    unit.visitChildren(ImportDirectiveVisitor(constrainedValues));
    unit.visitChildren(ResolvedClassVisitor(constrainedValues, ''));
  }

  Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
    ResolvedUnitResult placeholder;

    placeholder = await session.getResolvedUnit(path);
    return (placeholder.unit);
  }

  async.Future analyzeSingleFile(AnalysisContext context, String path) async {
    AnalysisSession session = context.currentSession;
    var unit = await getUnit(path, session);

    handleVisit(unit, path);
  }


  //TODO add constructor to methods to delete ? [NO]
  async.Future analyzeAllFiles(AnalysisContextCollection collection) async {
    for (AnalysisContext context in collection.contexts) {
      for (String path in context.contextRoot.analyzedFiles()) {
        if (path.endsWith('.dart') == false) {
          continue;
        }
        await analyzeSingleFile(context, path);
      }
    }
    //print(constrainedValues);

    var file = File(
        r'C:\Users\ImPar\OneDrive\Documents\codelink-dart-indexer\lib\testdir\yass\test.dart');
    var fileString = file.readAsStringSync();

     var iW = ImportWriter();

     iW.exec([
       'package:analyzer/dart/ast/ast',
       'package:analyzer/dart/ast/visitor',
       'FieldDeclarationVisitor',
       'ResolvedMethodVisitor',
     ],
         constrainedValues,
         ['../../Creator/Visitors/FieldDeclarationVisitor', '../test2'],
         fileString);
     fileString = iW.file;

    constrainedValues.forEach((element) {
      if (element.type != 'start-class')
        return;

      print('CA PASSE ICI');
      final code = '\n\rvoid func() {'
          'int i = 0;'
          'i++;' '}\n\r';

      //print(code);
      //fileString = ConstraintEditor.addToFile(ConstrainedValue(code, element.begin, element.begin + code.length, 'function'), constrainedValues, fileString);

      for (ConstrainedValue v in constrainedValues) {
        if (v.name == 'coucou') {
          fileString = ConstraintEditor.addToFile(ConstrainedValue('MDR', v.begin, v.begin + 3, 'function'), constrainedValues, fileString);
          break;
        }
      }
      var write = File('testNew.dart');
      write.writeAsString(fileString);
    });

  }

  void creator(List<dynamic> arguments, Function onEnd) async {
    var collection = AnalysisContextCollection(includedPaths: [arguments[0]]);

    await analyzeAllFiles(collection);

    //print('');
    // print(constrainedValues);
    //recomputeConstraint(methods, {'begin': 500, 'end': 555}, (a, b) => a + b);
    //print(attributes);
  }
}

void main(List<String> arguments) async {
  await DartCodeCreator(arguments, () {});
}
