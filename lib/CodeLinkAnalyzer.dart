import 'dart:convert';
import 'dart:io';
import 'dart:async' as async;

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';

const flutterPath = r'C:\flutter\packages\flutter\lib';
var file = {};
final funcs = [];
final classes = [];
var theClasses = {};
var inheritanceTree = {};

String constructInheritance(String toFind)
{
  final inherited = theClasses[toFind];
  if (inherited == null || inherited == 'null') {
    return (toFind);
  }
  return (toFind + '/' + constructInheritance(inherited));
}

void inheritanceTreeReconstruction() {
  theClasses.forEach((key, value) {
    inheritanceTree[key] = constructInheritance(value);
  });

}

class GetAnnotationTypes extends GeneralizingAstVisitor<void> {
  final param;

  GetAnnotationTypes(this.param);

  @override
  void visitLiteral(Literal literal) {
    param.add(
        {'type': literal.staticType.toString(), 'value': literal.toString()});
  }
}

List<dynamic> getAnnotations(NodeList<Annotation> annotationsList) {
  final annotations = [];

  for (final metadata in annotationsList) {
    final arr = [];

    metadata.visitChildren(GetAnnotationTypes(arr));
    annotations.add({'name': metadata.name.toString(), 'parameters': arr});
  }

  return (annotations);
}

class ResolvedFunctionVisitor extends SimpleAstVisitor<void> {
  List<dynamic> getParameters(FunctionDeclaration node) {
    final params = [];
    final parameterTypes = node.functionExpression.parameters.parameterElements
        .map((e) => e.type.getDisplayString(withNullability: false));
    final identifierNames =
    node.functionExpression.parameters.parameters.map((e) => e.identifier);

    for (var i = 0; i < parameterTypes.length; i++) {
      params.add({
        'type': parameterTypes.elementAt(i).toString(),
        'name': identifierNames.elementAt(i).toString()
      });
    }
    return (params);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    funcs.add({
      'name': node.name.toString(),
      'parameters': getParameters(node),
      'return': node.returnType.toString(),
      'annotations': getAnnotations(node.metadata),
      'code': node.functionExpression.body.toString()
    });
  }
}

class ResolvedMethodVisitor extends SimpleAstVisitor<void> {
  final newClass;

  ResolvedMethodVisitor(this.newClass);

  List<dynamic> getParameters(MethodDeclaration node) {
    final parameterTypes = node.parameters.parameterElements.map((e) =>
    {
      'type': e.type.getDisplayString(withNullability: false),
      'name': e.name.toString()
    });

    return (parameterTypes.toList());
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    List<dynamic> arr = newClass['methods'];

    arr.add({
      'name': node.name.toString(),
      'parameters': getParameters(node),
      'return': node.returnType.toString(),
      'annotations': getAnnotations(node.metadata),
      'code': node.body.toString()
    });
    newClass['methods'] = arr;
  }
}

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final newClass = {'name': node.name.toString(), 'methods': []};

    //node.visitChildren(ClassVisitor());
    node.visitChildren(ResolvedMethodVisitor(newClass));
    classes.add(newClass);
  }

}

class UnresolvedClassVisitor extends SimpleAstVisitor {

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause != null) {
      theClasses[node.name.toString()] = node.extendsClause.superclass.toString();
    } else {
      theClasses[node.name.toString()] = 'null';
    }
  }

}

void handleVisit(CompilationUnit unit, String path) {
  if (path.startsWith(flutterPath)) {
    unit.visitChildren(UnresolvedClassVisitor());
  } else {
    unit.visitChildren(ResolvedClassVisitor());
    unit.visitChildren(ResolvedFunctionVisitor());
  }
}

Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
  ResolvedUnitResult placeholder;

  //print('I handle $path');
  if (path.startsWith(flutterPath)) {
    //print('Lets go parsed.');
    return (session
        .getParsedUnit(path)
        .unit);
  } else {
    //print('Its resolved');
    placeholder = await session.getResolvedUnit(path);
    return (placeholder.unit);
  }
}



async.Future analyzeSingleFile(AnalysisContext context, String path) async {
  AnalysisSession session = context.currentSession;
  CompilationUnit unit = await getUnit(path, session);

  handleVisit(unit, path);
 // print('Analysis of $path is finished.');
}

async.Future analyzeAllFiles(AnalysisContextCollection collection) async {

  for (AnalysisContext context in collection.contexts) {

    for (String path in context.contextRoot.analyzedFiles()) {
      await analyzeSingleFile(context, path);
    }
  }
}

void printEverything() {
  final filename = 'classes.json';
  new File(filename).writeAsString(jsonEncode(theClasses));

  new File('inheritance.json').writeAsString(jsonEncode(inheritanceTree));

  file = {'funcs': funcs, 'classes': classes};
  new File("data.json").writeAsString(jsonEncode(file));
}

String getFlutterPath()
{
  final env = Platform.environment['PATH']?.split(';') ?? [];
  final realPath = Platform.pathSeparator + 'packages' + Platform.pathSeparator
                 + 'flutter' + Platform.pathSeparator + 'lib';
  var flutterPath = '';

  if (env.isEmpty) {
    return 'not found';
  }

  env.forEach((element) {
    if (element.contains('flutter' + Platform.pathSeparator + 'bin')) {
      flutterPath = element.replaceFirst(Platform.pathSeparator + 'bin', realPath);
    }
  });
  return (flutterPath);
}

void main() async {
  var includedPaths = <String>[];
  var collection;


  includedPaths.add(getFlutterPath());
  includedPaths.add(r'C:\Users\ImPar\OneDrive\Documents\codelink-dart-indexer\lib\testdir');
  collection = AnalysisContextCollection(includedPaths: includedPaths);

  await analyzeAllFiles(collection);
  inheritanceTreeReconstruction();
  printEverything();
}
