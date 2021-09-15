class CreatorParameters {

  String path = '';
  String view = '';
  dynamic code;

  CreatorParameters(dynamic data) {
    path = data['path'];
    view = data['view'];
    code = data['code'];
  }


}