import 'dart:io';

import '../ConstrainedValue.dart';
import 'CodeWriter.dart';
import 'ConstraintEditor.dart';

class ImportWriter extends CodeWriter {

  ImportWriter(String file) : super(file) {
    //final foundImport = constrainedValues.where((element) => element.type == 'import').toList();



  }

  void removeFromFile(List<String> removeList,
      List<ConstrainedValue> constrainedValues) {
    final importList = constrainedValues.where((e) => e.type == 'import');

    for (var toRemove in removeList) {
      final fullName = toRemove + '.dart';
      toRemove = "'$toRemove'";


      for (final constrainedValue in importList) {
        print('Try import ${constrainedValue.name} with $toRemove ? ${constrainedValue.type == 'import'} - ${toRemove == constrainedValue.name}');
        if (constrainedValue.type == 'import' &&
            toRemove == constrainedValue.name) {
          constrainedValues.remove(constrainedValue);
          file = ConstraintEditor.removeFromFile(constrainedValue, constrainedValues, file);
          break;
        }
      }
    }
  }

  void addToFile(List<String> importList, List<ConstrainedValue> constrainedValues) {
    for (final importToAdd in importList) {
      print('Trying to add $importToAdd');
      var name = "import '$importToAdd';\n";

      var tmp = ConstrainedValue(name, 0, name.length, 'import');

      file = ConstraintEditor.addToFile(tmp, constrainedValues, file);
      constrainedValues.add(tmp);
      addedData.add(importToAdd);
    }
  }

}