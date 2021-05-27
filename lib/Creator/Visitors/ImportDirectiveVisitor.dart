import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../ConstrainedValue.dart';

class ImportDirectiveVisitor extends SimpleAstVisitor<void> {
  final constrainedValues;

  ImportDirectiveVisitor(this.constrainedValues);

  @override
  void visitImportDirective(ImportDirective node) {
    constrainedValues.add(ConstrainedValue(
        node.selectedUriContent,
        node.keyword.charOffset.toInt(),
        node.endToken.charEnd.toInt(),
        'import'));
  }
}
