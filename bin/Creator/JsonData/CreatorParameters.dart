import 'RouteData.dart';

class CreatorParameters {

  String path = '';
  String view = '';
  dynamic code;
  List<RouteData> routes = [];

  CreatorParameters(dynamic data) {
    path = data['path'];
    view = data['view'];
    code = data['code'];
    data['routes'].forEach((route) {
      routes.add(RouteData(route));
    });
  }


}