import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../ConstrainedValue.dart';
import 'FieldDeclarationVisitor.dart';
import 'ResolvedMethodVisitor.dart';

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  List<ConstrainedValue> values;
  String classToLookFor;

  ResolvedClassVisitor(this.values, this.classToLookFor) {
    print(' look ? $classToLookFor');
    classToLookFor = '_${classToLookFor}State';
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaredElement = node.declaredElement;

    if (declaredElement == null) {
      return;
    }
    if (declaredElement.name.toString() == classToLookFor) {
      values.add(ConstrainedValue(
          node.name.toString(),
          node.leftBracket.charEnd.toInt(),
          node.leftBracket.charEnd.toInt(),
          'start-class'));
    } else {
      print('Looking for $classToLookFor but got ${declaredElement.name.toString()}');
    }
    node.visitChildren(ResolvedMethodVisitor(values));
    node.visitChildren(FieldDeclarationVisitor(values));
  }
}
