import 'MethodDeclarationData.dart';

class FieldDeclarationData extends MethodDeclarationData {

  List<FieldDeclarationData> children = [];

  FieldDeclarationData(dynamic data) : super(data) {
    if (data['children'] != null) {
      data['children'].forEach((child) {
        children.add(FieldDeclarationData(child));
      });
    }
  }

}