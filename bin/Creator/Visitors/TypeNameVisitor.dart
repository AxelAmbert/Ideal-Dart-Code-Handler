import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';


class TypeNameVisitor extends SimpleAstVisitor<void> {

  dynamic type;

  TypeNameVisitor(this.type);

  @override
  void visitNamedType(NamedType node) {
    print(' -> $node');
    type['len'] = node.toString().length;
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    print('List -> $node');
    node.visitChildren(TypeNameVisitor(type));
  }
}