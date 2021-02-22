import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';


var file = {};
final funcs = [];
final classes = [];
var theClasses = [];
var i = 0;


class Haha extends TypeVisitor<void> {
  @override
  void visitDynamicType(DynamicType type) {
    // TODO: implement visitDynamicType
  }

  @override
  void visitFunctionType(FunctionType type) {
    // TODO: implement visitFunctionType
  }

  @override
  void visitInterfaceType(InterfaceType type) {
    // TODO: implement visitInterfaceType
  }

  @override
  void visitNeverType(NeverType type) {
    // TODO: implement visitNeverType
  }

  @override
  void visitTypeParameterType(TypeParameterType type) {
    // TODO: implement visitTypeParameterType
  }

  @override
  void visitVoidType(VoidType type) {
    // TODO: implement visitVoidType
  }

}

class Generalized extends GeneralizingAstVisitor<void> {
  final param;

  Generalized(this.param);

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

    metadata.visitChildren(Generalized(arr));
    annotations.add({'name': metadata.name.toString(), 'parameters': arr});
  }

  return (annotations);
}

class FunctionVisitor extends SimpleAstVisitor<void> {
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

class MethodVisitor extends SimpleAstVisitor<void> {
  final newClass;

  MethodVisitor(this.newClass);

  List<dynamic> getParameters(MethodDeclaration node) {
    final parameterTypes = node.parameters.parameterElements.map((e) => {
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

class Heritage extends SimpleAstVisitor<void> {

  @override
  void visitTypeName(TypeName node) {
    //print('Type name -> ${node}');

  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    //print('Simple ? $node');
    node.visitChildren(Heritage());
  }

}

class ClassVisitor extends SimpleAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    //print('Je visite -> ${node.name}');
    final newClass = {'name': node.name.toString(), 'methods': []};
    theClasses.add(node.name.toString());
    //node.visitChildren(ClassVisitor());
    //node.visitChildren(MethodVisitor(newClass));
    //classes.add(newClass);
  }
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {

  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {

  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {

  }
  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {

  }

  @override
  void visitTypeParameterList(TypeParameterList node) {
  }

  @override
  void visitExtendsClause(ExtendsClause node) {

    //print('$node inherits ${node.superclass} -> ');

    node.visitChildren(Heritage());
  }

/*
  @override
  void visitImportDirective(ImportDirective node) async {
    //print('Lets go import ! ${node.selectedSource.toString()}');
      final s = await resolveFile(path: node.selectedSource.toString());
      for (final l in s.unit.childEntities) {
          print('mdr ${l}');
      }
      //s.unit.visitChildren(Thrower());
      //s.unit.visitChildren(FunctionVisitor());
      s.unit.visitChildren(ClassVisitor());
    //print('Import ? $node');
    //print(node.selectedSource);

  }*/
/*
  @override
  void visitExportDirective(ExportDirective node) async {
    print('Lets go export ! ${node.selectedSource.toString()}');
    final s = await resolveFile(path: node.selectedSource.toString());
    //s.unit.visitChildren(FunctionVisitor());
    s.unit.visitChildren(ClassVisitor());

    //print('Import ? $node');
    //print(node.selectedSource);

  }*/
  /*
  @override
  void visitLibraryDirective(LibraryDirective node)
  {
    node.visitChildren(ClassVisitor());
    print("Lib");
  }*/
/*  @override
  void visitTypeParameterList(TypeParameterList node) {
    print('Type ? ${node} parent ? ${node.parent}');

  }*/
}

class Thrower extends ThrowingAstVisitor<void>
{
  @override
  void visitLibraryDirective(LibraryDirective node)
  {
    node.visitChildren(ClassVisitor());
    print("Lib");
  }
}
/*
void main(List<String> arguments) async {
  //final fileName = Directory.current.path + Platform.pathSeparator + 'test.dart';
  final fileName = r'C:\Users\ImPar\test\mdr\lib\test.dart';
  var source = null;

  //print(fileName);
  //print(Platform.resolvedExecutable);

  try {
    source = await resolveFile(path: fileName);

    file['functions'] = [];
    file['classes'] = [];

    source.unit.visitChildren(FunctionVisitor());
    source.unit.visitChildren(ClassVisitor());
    file = {'funcs': funcs, 'classes': classes};
    new File("data.json").writeAsString(jsonEncode(file));
  } catch (e, s) {
    print('${s}');
  }
}*/

void analyzeSingleFile(AnalysisContext context, String path) {
  AnalysisSession session = context.currentSession;
  ParsedUnitResult result = session.getParsedUnit(path);
  CompilationUnit unit = result.unit;

  unit.visitChildren(ClassVisitor());
  print('Analysis of $path is finished.');
}

void analyzeAllFiles(AnalysisContextCollection collection) {
  var i = 0;
  for (AnalysisContext context in collection.contexts) {
    for (String path in context.contextRoot.analyzedFiles()) {
      analyzeSingleFile(context, path);
      i++;
    }
  }
  print('Number of analyzed files ? $i');
}


void printarr() {
  final filename = 'classes.txt';
  new File(filename).writeAsString(theClasses.join('\n'));
}

void main() {
  List<String> includedPaths = [];
  var collection;

  includedPaths.add(r'C:\flutter\packages\flutter\lib');
  collection = AnalysisContextCollection(includedPaths: includedPaths);

  analyzeAllFiles(collection);
  printarr();
}
