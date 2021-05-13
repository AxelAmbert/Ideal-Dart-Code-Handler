import 'dart:convert';
import 'dart:io';
import 'dart:async' as async;

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/constant/value.dart';

var flutterPath = '';
var file = {};
final funcs = [];
final classes = [];
final variables = [];
var theClasses = {};
var inheritanceTree = {};
var deepFlutterAnalysis = false;

String constructInheritance(String toFind)
{
  final inherited = theClasses[toFind];
  if (inherited == null || inherited == 'null') {
    return (toFind);
  }
  return (toFind + '/' + constructInheritance(inherited));
}

void inheritanceTreeReconstruction() {
  theClasses.forEach((key, value) {
    inheritanceTree[key] = constructInheritance(value);
  });

}

class GetAnnotationTypes extends GeneralizingAstVisitor<void> {
  final param;

  GetAnnotationTypes(this.param);

  @override
  void visitLiteral(Literal literal) {
    param.add(
        {'type': literal.staticType.toString(), 'value': literal.toString()});
  }
}

List<dynamic> getAnnotations(NodeList<Annotation> annotationsList) {
  final annotations = [];

  for (final metadata in annotationsList) {
    final arr = [];

    metadata.visitChildren(GetAnnotationTypes(arr));
    annotations.add({'name': metadata.name.toString(), 'parameters': arr});
  }

  return (annotations);
}

String getComputedValue(VariableDeclaration element)
{
  final type = element.declaredElement.computeConstantValue();
  
  if (type == null || type.hasKnownValue == false)
    return ('');
  else if (type.toBoolValue() != null)
    return (type.toBoolValue().toString());
  else if (type.toStringValue() != null)
    return (type.toStringValue());
  else if (type.toIntValue() != null)
    return (type.toIntValue().toString());
  return ('');
}


class TopLevelVariableVisitor extends SimpleAstVisitor<void> {
  @override
  visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    node.variables.variables.forEach((element) {
      variables.add({
        'name': element.name.toString(),
        'type': element.declaredElement.type.toString(),
        'value': getComputedValue(element)
      });
    });
  }
}

class ResolvedFunctionVisitor extends SimpleAstVisitor<void> {

  dynamic getIdentifierInfos(FunctionDeclaration node)
  {
    final values = node.functionExpression.parameters.parameters.map((e) {
      final v = {};

      v['id'] = e.identifier;
      v['isNamed'] = e.isNamed;
      v['isRequired'] = e.isRequired;
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
        'isRequired': info['isRequired'].toString()
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
        //'code': node.functionExpression.body.toString()
      });
    } catch (e) {
      return;
    }
  }
}

class ResolvedMethodVisitor extends SimpleAstVisitor<void> {
  final newClass;

  ResolvedMethodVisitor(this.newClass);

  List<dynamic> getParameters(FormalParameterList list) {
    final parameterTypes = list.parameterElements.map((e) =>
    {
      'type': e.type.getDisplayString(withNullability: false),
      'name': e.name.toString()
    });

    return (parameterTypes.toList());
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    List<dynamic> arr = newClass['constructors'];

    try {
      arr.add({
        'isMainConstructor': node.name == null ? true : false,
        'name': node.name?.toString(),
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

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final newClass = {'name': node.name.toString(), 'methods': [], 'constructors': []};

    node.visitChildren(ResolvedMethodVisitor(newClass));
    classes.add(newClass);
  }

}

class UnresolvedClassVisitor extends SimpleAstVisitor {

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause != null) {
      theClasses[node.name.toString()] = node.extendsClause.superclass.toString();
    } else {
      theClasses[node.name.toString()] = 'null';
    }
  }

}

void handleVisit(CompilationUnit unit, String path) {
  if (path.startsWith(flutterPath) && deepFlutterAnalysis == false) {
    unit.visitChildren(UnresolvedClassVisitor());
  } else {
    unit.visitChildren(ResolvedClassVisitor());
    unit.visitChildren(ResolvedFunctionVisitor());
    unit.visitChildren(TopLevelVariableVisitor());
  }
}

Future<CompilationUnit> getUnit(String path, AnalysisSession session) async {
  ResolvedUnitResult placeholder;

  if (path.startsWith(flutterPath) && deepFlutterAnalysis == false) {
    return (session.getParsedUnit(path).unit);
  } else {
    placeholder = await session.getResolvedUnit(path);
    return (placeholder.unit);
  }
}



async.Future analyzeSingleFile(AnalysisContext context, String path) async {
  AnalysisSession session = context.currentSession;
  CompilationUnit unit = await getUnit(path, session);

  handleVisit(unit, path);
}



async.Future analyzeAllFiles(AnalysisContextCollection collection) async {

  for (AnalysisContext context in collection.contexts) {

    for (String path in context.contextRoot.analyzedFiles()) {
      //print('Analyzing ${path}');
      if (path.endsWith(".dart") == false) {
        continue;
      }
      await analyzeSingleFile(context, path);
      //print('End of the analyzis of ${path}');
    }
  }
}

void printEverything() {
  final filename = 'classes.json';
  new File(filename).writeAsString(jsonEncode(theClasses));

  new File('inheritance.json').writeAsString(jsonEncode(inheritanceTree));

  file = {'funcs': funcs, 'classes': classes, 'constValues': variables};
  new File("data.json").writeAsString(jsonEncode(file));
}

String getFlutterPath()
{
  final env = Platform.environment['PATH']?.split(';') ?? [];
  final realPath = Platform.pathSeparator + 'packages' + Platform.pathSeparator
                 + 'flutter' + Platform.pathSeparator + 'lib';
  var flutterPath = '';

  if (env.isEmpty) {
    return 'not found';
  }

  env.forEach((element) {
    if (element.contains('flutter' + Platform.pathSeparator + 'bin')) {
      flutterPath = element.replaceFirst(Platform.pathSeparator + 'bin', realPath);
    }
  });
  return (flutterPath);
}

void main(List<String> arguments) async {
  var includedPaths = <String>[];
  var collection;

  if (arguments.isNotEmpty && arguments.first == 'deep') {
    print('Deep analysis enabled');
    deepFlutterAnalysis = true;
  }
  flutterPath = getFlutterPath();
  includedPaths.add(flutterPath);
  includedPaths.add(r'C:\Users\ImPar\OneDrive\Documents\codelink-dart-indexer\lib\testdir');
  collection = AnalysisContextCollection(includedPaths: includedPaths);

  await analyzeAllFiles(collection);
  inheritanceTreeReconstruction();
  printEverything();
}
