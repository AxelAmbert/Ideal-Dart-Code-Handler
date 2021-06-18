import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';


class TypeNameVisitor extends SimpleAstVisitor<void> {

  dynamic type;

  TypeNameVisitor(this.type);

  @override
  void visitTypeName(TypeName node) {
    type['name'] = node.toString();
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    node.visitChildren(TypeNameVisitor(type));
  }
}