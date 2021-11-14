import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import '../JsonData/IndexerParameters.dart';
import 'ResolvedMethodVisitor.dart';
import '../MiscFunctions.dart';

class ResolvedClassVisitor extends SimpleAstVisitor<void> {
  final String path;
  final dynamic classes;
  final IndexerParameters programData;

  ResolvedClassVisitor(this.path, this.classes, this.programData);

  @override
  void visitClassDeclaration(ClassDeclaration node) {


    if (node.name.toString().startsWith('_')) {
      return;
    }
    final newClass = {
      'name': node.name.toString(),
      'methods': [],
      'constructors': [],
      'path': path,
      'import': removePrefixFromPath(path, programData.flutterLibPath, programData.uselessPath),
      'extendsAClass?': false,
      'extends': '',
    };
    if (node.extendsClause != null) {

      newClass['extendsAClass?'] = true;
      newClass['extends'] = node.extendsClause!.superclass2.name.toString();
    }
    node.visitChildren(ResolvedMethodVisitor(newClass));
    classes.add(newClass);
  }
}