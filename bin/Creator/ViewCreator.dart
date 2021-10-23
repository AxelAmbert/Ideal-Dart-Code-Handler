class ViewCreator {

  static String createView(viewName) {
    return """
import 'package:flutter/material.dart';

class $viewName extends StatefulWidget {
  $viewName({Key? key}) : super(key: key);

  @override
  _${viewName}State createState() => _${viewName}State();
}

class _${viewName}State extends State<$viewName> {


  _${viewName}State() {
    CodeLinkInit();
    variableInit();
  }
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: SafeArea(
            child: placeholder,
            top: true,
          ),
      );
    }
}
""";
  }

  static String createMain({appName = 'IdealApp'}) {
    return """

import 'dart:async';
import 'package:flutter/material.dart';
import 'routes.dart';

Future<void> main() async {
  runApp(
    MaterialApp(
      title: '$appName',
      initialRoute: '/',
      routes: materialRoutes,
    ),
  );
}
  """;
  }
}