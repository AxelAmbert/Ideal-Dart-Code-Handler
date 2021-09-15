import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../MiscFunctions.dart';
import 'GetAnnotationTypes.dart';

class ResolvedFunctionVisitor extends SimpleAstVisitor<void> {

  final String path;
  final dynamic funcs;

  ResolvedFunctionVisitor(this.path, this.funcs);

  dynamic getIdentifierInfos(FunctionDeclaration node) {
    final values = node.functionExpression.parameters.parameters.map((e) {
      final v = {};

      v['id'] = e.identifier;
      v['isNamed'] = e.isNamed;
      v['isRequired'] = e.isRequired.toString();
      return (v);
    });

    return (values);
  }

  List<dynamic> getParameters(FunctionDeclaration node) {
    final params = [];
    final parameterTypes = node.functionExpression.parameters.parameterElements
        .map((e) => e.type.getDisplayString(withNullability: false));
    final identifierInfos = getIdentifierInfos(node);

    for (var i = 0; i < parameterTypes.length; i++) {
      final info = identifierInfos.elementAt(i);

      params.add({
        'type': parameterTypes.elementAt(i).toString(),
        'name': info['id'].toString(),
        'isNamed': info['isNamed'].toString(),
        'isRequired': info['isRequired'].toString(),
      });
    }
    return (params);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    try {
      funcs.add({
        'name': node.name.toString(),
        'parameters': getParameters(node),
        'return': node.returnType.toString(),
        'annotations': getAnnotations(node.metadata),
        'path': path,
        //'import': removePrefixFromPath(path)

        //'code': node.functionExpression.body.toString()
      });
    } catch (e) {
      return;
    }
  }
}