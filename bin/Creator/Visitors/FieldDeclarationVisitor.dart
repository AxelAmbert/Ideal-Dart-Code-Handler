import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../ConstrainedValue.dart';
import 'TypeNameVisitor.dart';



class FieldDeclarationVisitor extends SimpleAstVisitor<void> {
  final attributes;

  FieldDeclarationVisitor(this.attributes);


  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    var name = '';
    final typename = {'len': 0};


    node.visitChildren(TypeNameVisitor(typename));
    node.fields.variables.forEach((element) {
      name = element.name.toString();
    });

    // If it founds no type, assume the type is 'var'
    if (typename['len'] == 0) {
      typename['len'] = 3;
    }

    attributes.add(ConstrainedValue(
        name,
        node.beginToken.charEnd.toInt() -  int.parse(typename['len'].toString()),
        node.endToken.charEnd.toInt(),
        'declaration'));
  }
}
