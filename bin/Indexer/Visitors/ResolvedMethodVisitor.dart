import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../MiscFunctions.dart';

class ResolvedMethodVisitor extends SimpleAstVisitor<void> {
  final newClass;

  ResolvedMethodVisitor(this.newClass);



  List<dynamic> getParameters(FormalParameterList list) {
    final parameterTypes = list.parameterElements.map((e) => {
      'type': e.type.getDisplayString(withNullability: false),
      'name': e.name.toString(),
      'isRequired':
      (e.hasRequired || e.isRequiredNamed || e.isRequiredPositional)
          .toString(),
    });

    return (parameterTypes.toList());
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    List<dynamic> arr = newClass['constructors'];

    try {
      arr.add({
        'isMainConstructor': node.name == null ? 'true' : 'false',
        'name': node.name != null ? node.name.toString() : 'null',
        'parameters': getParameters(node.parameters)
      });
    } catch (e) {
      return;
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    List<dynamic> arr = newClass['methods'];

    try {
      if (node.name.toString().startsWith('_')) {
        return;
      }

      arr.add({
        'name': node.name.toString(),
        'parameters': getParameters(node.parameters),
        'return': node.returnType.toString(),
        'annotations': getAnnotations(node.metadata),
        //'code': node.body.toString()
      });
    } catch (e) {
      return;
    }
    newClass['methods'] = arr;
  }
}