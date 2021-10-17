import 'FieldDeclarationData.dart';
import 'MethodDeclarationData.dart';

class CreatorData {

  List<String> imports = [];
  List<MethodDeclarationData> methodDeclarations = [];
  List<FieldDeclarationData> fieldDeclarations = [];

  void addInitToMethod(dynamic data) {
    data['functions'].add({
      'name': 'variableInit',
      'code': data['initialization']
    });
  }

  CreatorData(dynamic data) {
    addInitToMethod(data);
    imports = data['imports'].cast<String>();

    data['functions'].forEach((methodData) {
      methodDeclarations.add(MethodDeclarationData(methodData));
    });

    data['declarations'].forEach((declaration) {
      fieldDeclarations.add(FieldDeclarationData(declaration));
    });
  }

}