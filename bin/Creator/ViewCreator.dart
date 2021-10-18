class ViewCreator {

  static String createView(viewName) {
    return """
import 'package:flutter/material.dart';

class ${viewName}Page extends StatefulWidget {
  ${viewName}Page({Key key}) : super(key: key);

  @override
  _${viewName}PageState createState() => _${viewName}PageState();
}

class _${viewName}PageState extends State<${viewName}Page> {

  _${viewName}PageState() {}
  
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