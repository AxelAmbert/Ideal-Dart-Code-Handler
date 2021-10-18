import 'dart:io';

import '../JsonData/CreatorParameters.dart';
import 'package:path/path.dart' as path;

class RouteWriter {

  static String _buildCode(data) {
    var importBuffer = '';
    var routingBuffer = 'final materialRoutes = {\n';

    data.routes.forEach((route) {
      importBuffer += "import '${route.view}.dart';\n";
      routingBuffer += "'${route.view}': (context) => const ${route.view},\n";
    });
    routingBuffer += '};\n';
    return importBuffer + routingBuffer;
  }

  static void write(CreatorParameters data) {
    final code = _buildCode(data);
    final pathToWrite = path.join(data.path, 'lib', 'routes.dart');

    File(pathToWrite).writeAsStringSync(code);
  }

}