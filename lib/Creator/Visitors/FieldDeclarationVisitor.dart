import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../ConstrainedValue.dart';

class FieldDeclarationVisitor extends SimpleAstVisitor<void> {
  final attributes;

  FieldDeclarationVisitor(this.attributes);

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    var name = '';

    node.fields.variables.forEach((element) {
      name = element.declaredElement.name.toString();
    });

    attributes.add(ConstrainedValue(
        name,
        node.beginToken.charEnd.toInt(),
        node.endToken.charEnd.toInt(),
        'field'));
  }
}
