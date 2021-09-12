import 'dart:io';

import '../ConstrainedValue.dart';
import '../JsonData/MethodDeclarationData.dart';
import 'CodeWriter.dart';
import 'ConstraintEditor.dart';

class MethodWriter extends CodeWriter {


  MethodWriter(String file) : super(file);

  void removeFromFile(List<String> removeList,
      List<ConstrainedValue> constrainedValues) {
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

  void addToFile(List<MethodDeclarationData> methodList, List<ConstrainedValue> constrainedValues) {

    for (final methodToAdd in methodList) {
      final method = '\nvoid ${methodToAdd.name}() {\n${methodToAdd.code}\n}';
      final start = findConstrainedStartOfClass(constrainedValues);
      final tmp = ConstrainedValue(method, start, start + method.length, 'method');

      file = ConstraintEditor.addToFile(tmp, constrainedValues, file);
      constrainedValues.add(tmp);
      addedData.add(methodToAdd.name);

    }
  }

}