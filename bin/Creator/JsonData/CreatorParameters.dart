import 'RouteData.dart';

class CreatorParameters {

  String path = '';
  List<String> views = [];
  List<dynamic> viewsCode = [];
  List<RouteData> routes = [];

  CreatorParameters(dynamic data) {
    path = data['path'];
    views = data['views'].cast<String>();
    viewsCode = data['viewsCode'];
    data['routes'].forEach((route) {
      routes.add(RouteData(route));
    });
  }


}