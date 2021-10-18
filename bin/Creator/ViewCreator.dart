class ViewCreator {

  static String createView(viewName) {
    return """
import 'package:flutter/material.dart';

class $viewName extends StatefulWidget {
  $viewName({Key key}) : super(key: key);

  @override
  _$viewName createState() => _${viewName}State();
}

class _${viewName}State extends State<$viewName> {

  _${viewName}State() {}
  
  @override
    Widget build(BuildContext context) {
      return Scaffold(
          body: idealScaffold()
      );
    }
}
""";
  }

  static String createMain({appName = 'IdealApp'}) {
    return """

import 'dart:async';
import 'package:flutter/material.dart';
import 'routing.dart';

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