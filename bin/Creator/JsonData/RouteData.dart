class RouteData {
  String path = '';
  String name = '';

  RouteData(route) {
    path = route['path'];
    name = route['name'];
  }
}