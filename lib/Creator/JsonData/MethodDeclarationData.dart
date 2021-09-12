class MethodDeclarationData {
  String name = '';
  String code = '';

  MethodDeclarationData(dynamic data) {
    name = data['name'];
    code = data['code'];
  }

}