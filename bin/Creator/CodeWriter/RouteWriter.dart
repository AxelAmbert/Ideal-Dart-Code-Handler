import 'dart:io';

import '../JsonData/CreatorData.dart';
import '../JsonData/CreatorParameters.dart';
import 'package:path/path.dart' as path;

class RouteWriter {

  static String buildCode(data) {
    var importBuffer = '';
    var routingBuffer = 'final materialRoutes = {\n';

    data.routes.forEach((route) {
      importBuffer += "import '${route.view}.dart';\n";
      routingBuffer += "'${route.path}': (context) => ${route.view}(),\n";
    });
    routingBuffer += '};\n';
    return importBuffer + routingBuffer;
  }

  static void write(CreatorParameters parameters) {
    final code = buildCode(parameters);
    final pathToWrite = path.join(parameters.path, 'lib', 'routes.dart');

    File(pathToWrite).writeAsStringSync(code);
  }

}