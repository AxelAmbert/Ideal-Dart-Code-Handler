class ProgramParameters {

  String path = '';
  String view = '';
  dynamic code;

  ProgramParameters(dynamic data) {
    path = data['path'];
    view = data['view'];
    code = data['code'];
  }


}