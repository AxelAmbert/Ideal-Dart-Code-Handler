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


    print('Field -> $node');
    node.visitChildren(TypeNameVisitor(typename));
    node.fields.variables.forEach((element) {
      name = element.name.toString();
      print('Name $name');
      print('Name name ${element.name.toString()}');

      /*

      print('Elem ${element.toString()}');
      final declaredElement = element.declaredElement;

      if (declaredElement == null) {
        return;
      }
      name = declaredElement.name.toString();
      print('Name ? $name');*/
    });

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
