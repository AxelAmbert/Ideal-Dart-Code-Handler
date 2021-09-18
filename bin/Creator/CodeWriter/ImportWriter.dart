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

    for (final toRemove in removeList) {
      final fullName = toRemove + '.dart';

      for (final constrainedValue in importList) {
        if (constrainedValue.type == 'import' &&
            fullName == constrainedValue.name) {
          constrainedValues.remove(constrainedValue);
          file = ConstraintEditor.removeFromFile(constrainedValue, constrainedValues, file);
          break;
        }
      }
    }
  }

  void addToFile(List<String> importList, List<ConstrainedValue> constrainedValues) {
    for (final importToAdd in importList) {
      var name = "import '" + importToAdd;

      var tmp = ConstrainedValue(name, 0, name.length, 'import');

      file = ConstraintEditor.addToFile(tmp, constrainedValues, file);
      constrainedValues.add(tmp);
      addedData.add(name);
    }
  }

}