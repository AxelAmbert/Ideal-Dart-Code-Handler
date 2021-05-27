import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../ConstrainedValue.dart';

class ResolvedMethodVisitor extends SimpleAstVisitor<void> {
  final constrainedValues;

  ResolvedMethodVisitor(this.constrainedValues);

/*
  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    List<dynamic> arr = methods['constructors'];

    try {
      arr.add({
        'isMainConstructor': node.name == null ? 'true' : 'false',
        'name': node.name != null ? node.name.toString() : 'null',
        'parameters': getParameters(node.parameters)
      });
    } catch (e) {
      return;
    }
  }*/

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    constrainedValues.add(ConstrainedValue(
        node.name.toString(),
        node.beginToken.charEnd.toInt(),
        node.endToken.charEnd.toInt(),
        'method'));
  }
}
