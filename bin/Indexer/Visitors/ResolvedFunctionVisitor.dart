import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../JsonData/IndexerParameters.dart';
import '../MiscFunctions.dart';
import 'GetAnnotationTypes.dart';

class ResolvedFunctionVisitor extends SimpleAstVisitor<void> {
  final String path;
  final dynamic funcs;
  final IndexerParameters programData;


  ResolvedFunctionVisitor(this.path, this.funcs, this.programData);

  dynamic getIdentifierInfos(FunctionDeclaration node) {
    final parameters = node.functionExpression.parameters;

    if (parameters == null) {
      return;
    }

    final values = parameters.parameters.map((e) {
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
    final parameters = node.functionExpression.parameters;

    if (parameters == null) {
      return params;
    }
    final parameterTypes = parameters.parameterElements
        .map((e) {
          if (e == null) {
            return '';
          }
          return e.type.getDisplayString(withNullability: false);
        });
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

  void getBody(FunctionDeclaration node, dynamic element) {

    element['annotations']?.forEach((annotation)  {
      if (annotation['name'] == 'InlineFunction' ||
          annotation?['name'] == 'InsideFunction') {
        element['body'] = node.functionExpression.body.toString();
      }
    });
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    try {
      if (node.name.toString().startsWith('_')) {
        return;
      }
      final newElement = {
        'name': node.name.toString(),
        'parameters': getParameters(node),
        'return': node.returnType.toString(),
        'annotations': getAnnotations(node.metadata),
        'path': path,
        'import': removePrefixFromPath(path, programData.flutterLibPath, programData.uselessPath),
        'body': null,
        //'code': node.functionExpression.body.toString()
      };
      getBody(node, newElement);
      if (isNotHidden(newElement['annotations'])) {
        funcs.add(newElement);
      }
    } catch (e) {
      print(e);
      return;
    }
  }
}
