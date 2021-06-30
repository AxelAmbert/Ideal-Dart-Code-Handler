class DeclarationData {
  String name = '';
  String code = '';

  DeclarationData(dynamic data) {
    name = data['name'];
    code = data['code'];
  }

}