import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';


class TypeNameVisitor extends SimpleAstVisitor<void> {

  dynamic type;

  TypeNameVisitor(this.type);

  @override
  void visitNamedType(NamedType node) {
    type['len'] = node.toString().length;
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    node.visitChildren(TypeNameVisitor(type));
  }
}