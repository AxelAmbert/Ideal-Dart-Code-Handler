class RouteData {
  String path = '';
  String view = '';

  RouteData(route) {
    path = route['path'];
    view = route['view'];
  }
}