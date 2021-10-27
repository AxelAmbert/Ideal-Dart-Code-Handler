import 'CreatorParameters.dart';
import 'FieldDeclarationData.dart';
import 'MethodDeclarationData.dart';

class CreatorData {

  String view = '';
  String path = '';
  List<String> imports = [];
  List<MethodDeclarationData> methodDeclarations = [];
  List<FieldDeclarationData> fieldDeclarations = [];

  void addInitToMethod(dynamic data) {
    data['functions'].add({
      'name': 'variableInit',
      'code': data['initialization']
    });
  }

  CreatorData(CreatorParameters parameters, int viewIndex) {
    dynamic code = parameters.viewsCode[viewIndex];

    addInitToMethod(code);
    imports = code['imports'].cast<String>();
    view = parameters.views[viewIndex];
    path = parameters.path;

    code['functions'].forEach((methodData) {
      methodDeclarations.add(MethodDeclarationData(methodData));
    });

    code['declarations'].forEach((declaration) {
      fieldDeclarations.add(FieldDeclarationData(declaration));
    });
  }

}