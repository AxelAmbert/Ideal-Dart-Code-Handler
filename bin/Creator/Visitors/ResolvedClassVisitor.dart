import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../ConstrainedValue.dart';
import 'FieldDeclarationVisitor.dart';
import 'ResolvedMethodVisitor.dart';

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  List<ConstrainedValue> values;
  final String classToLookFor;

  ResolvedClassVisitor(this.values, this.classToLookFor);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final declaredElement = node.declaredElement;

    if (declaredElement == null) {
      return;
    }
    print('Je visite ${declaredElement.name.toString()}');
    if (declaredElement.name.toString() == 'Main') {

      values.add(ConstrainedValue(
          node.name.toString(),
          node.leftBracket.charEnd.toInt(),
          node.leftBracket.charEnd.toInt(),
          'start-class'));
    }
    /*
    TODO add back this part of the code when testing finishes
    if (node.name.toString() != classToLookFor) {<<<
      return;
    }
    */
    node.visitChildren(ResolvedMethodVisitor(values));
    node.visitChildren(FieldDeclarationVisitor(values));
  }
}
