import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'Visitors/GetAnnotationTypes.dart';


String removePrefixFromPath(String path, flutterPath, uselessPath) {
  final separator = Platform.pathSeparator;

  print('Flutter path ${flutterPath}');
  if (path.startsWith(flutterPath)) {
    print('It starts with a flutter path');
    var builder = path.replaceAll(flutterPath, '');
    var split = builder.split(separator);

    if (split.length < 4) {
      print('For ${split} it is ${split.length}');
      return path;
    }
    builder = 'package:flutter/' + split[2] + '.dart';
    return (builder);
  } else {
    print('it does not starts with a flutter path');
    path = path.replaceAll(uselessPath, '').replaceAll('\\', '/');
    path = 'codelink/user$path';
  }
  return (path);
}

List<dynamic> getAnnotations(NodeList<Annotation> annotationsList) {
  final annotations = [];

  for (final metadata in annotationsList) {
    final arr = [];

    metadata.visitChildren(GetAnnotationTypes(arr));
    annotations.add({'name': metadata.name.toString(), 'parameters': arr});
  }

  return (annotations);
}


String constructInheritance(dynamic theClasses, String toFind) {
  final inherited = theClasses[toFind];

  if (inherited == null || inherited == 'null') {
    return (toFind);
  }
  return (toFind + '/' + constructInheritance(theClasses, inherited));
}

dynamic inheritanceTreeReconstruction(dynamic theClasses) {
  final inheritanceTree = {};

  theClasses.forEach((key, value) {
    inheritanceTree[key] = constructInheritance(theClasses, value);
  });
  return (inheritanceTree);
}

String handleWindowsDirectoryCreation(String fullPath) {
  if (Directory(fullPath).existsSync() == false) {
    Directory(fullPath).createSync(recursive: false);
  }
  return (fullPath);
}

String handleLinuxDirectoryCreation(String fullPath) {

  if (Directory(fullPath).existsSync() == false) {
    Directory(fullPath).createSync(recursive: false);
  }
  return (fullPath);
}

String createDirectory(String where, String directoryName) {
  final fullPath = where + Platform.pathSeparator + directoryName;

  if (Platform.isWindows) {
    return (handleWindowsDirectoryCreation(fullPath));
  } else if (Platform.isLinux) {
    return (handleLinuxDirectoryCreation(fullPath));
  } else if (Platform.isMacOS) {
    //return (forMacOS());
  }
  return ('ERROR');
}

String generateRandomName() {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(15, (index) => _chars[r.nextInt(_chars.length)]).join();
}