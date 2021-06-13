import 'dart:io';

import '../ConstrainedValue.dart';
import 'ConstraintEditor.dart';

class MethodWriter {

  String file = '';
  List<String> createdMethods = [];

  MethodWriter();


  void exec(List<String> methodList, List<ConstrainedValue> constrainedValues,
      List<String> removeList, String file) {
    removeEveryMethodFromFile(removeList, constrainedValues, file);
    addMethodToFile(methodList, constrainedValues, file);
  }

  void removeEveryMethodFromFile(List<String> removeList,
      List<ConstrainedValue> constrainedValues, String file) {
    final methodList = constrainedValues.where((e) => e.type == 'method');

    for (final toRemove in removeList) {
      for (final constrainedValue in methodList) {
        if (constrainedValue.type == 'method' &&
            toRemove == constrainedValue.name) {
          constrainedValues.remove(constrainedValue);
          file = ConstraintEditor.removeFromFile(constrainedValue, constrainedValues, file);
          break;
        }
      }
    }
  }

  int findConstrainedStartOfClass(List<ConstrainedValue> constrainedValues) {
    for (final constrainedValue in constrainedValues) {
      if (constrainedValue.type == 'start-class') {
        return (constrainedValue.begin);
      }
    }
    throw Exception('Start class not found');
  }

  void addMethodToFile(dynamic methodList, List<ConstrainedValue> constrainedValues, String file) {

    for (final methodToAdd in methodList) {
      final method = '\nvoid ${methodToAdd['name']}() {\n${methodToAdd['code']}\n}';
      final start = findConstrainedStartOfClass(constrainedValues);
      final tmp = ConstrainedValue(method, start, method.length, 'method');

      file = ConstraintEditor.addToFile(tmp, constrainedValues, file);
      constrainedValues.add(tmp);
      createdMethods.add(methodToAdd['name']);
    }
  }

}