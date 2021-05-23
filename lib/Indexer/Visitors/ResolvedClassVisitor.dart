import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'ResolvedMethodVisitor.dart';
import '../MiscFunctions.dart';

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  final String path;
  final dynamic classes;
  final dynamic programData;

  ResolvedClassVisitor(this.path, this.classes, this.programData);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final newClass = {
      'name': node.name.toString(),
      'methods': [],
      'constructors': [],
      'path': path,
      'import': removePrefixFromPath(path, programData['flutterPath'], programData['uselessPath']),
    };

    node.visitChildren(ResolvedMethodVisitor(newClass));
    classes.add(newClass);
  }
}