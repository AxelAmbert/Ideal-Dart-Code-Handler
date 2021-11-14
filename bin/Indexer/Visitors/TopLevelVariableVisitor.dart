import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';



class TopLevelVariableVisitor extends SimpleAstVisitor<void> {

  final variables;

  TopLevelVariableVisitor(this.variables);

  String getComputedValue(VariableDeclaration element) {
    final type = element.declaredElement?.computeConstantValue();

    if (type == null || type.hasKnownValue == false) {
      return ('');
    } else if (type.toBoolValue() != null) {
      return (type.toBoolValue().toString());
    } else if (type.toStringValue() != null) {
      return (type.toStringValue() ?? '');
    } else if (type.toIntValue() != null) {
      return (type.toIntValue().toString());
    }
    return ('');
  }


  @override
  visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {

    node.variables.variables.forEach((element) {
      if (element.name.toString().startsWith('_')) {
        return;
      }
      variables.add({
        'name': element.name.toString(),
        'type': element.declaredElement?.type.toString(),
        'value': getComputedValue(element)
      });
    });
  }
}