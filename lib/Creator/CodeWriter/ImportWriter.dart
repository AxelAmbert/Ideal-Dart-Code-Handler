import 'dart:io';

import '../ConstrainedValue.dart';
import 'FileWriter.dart';

class ImportWriter {

  dynamic importToWrite;
  String file;

  ImportWriter(dynamic importList, List<ConstrainedValue> constrainedValues,
      dynamic removeList, this.file) {
    //final foundImport = constrainedValues.where((element) => element.type == 'import').toList();

    removeEveryImportFromFile(removeList, constrainedValues);
    addImportToFile(importList, constrainedValues);

  }


  void removeEveryImportFromFile(List<String> removeList,
      List<ConstrainedValue> constrainedValues) {
    final importList = constrainedValues.where((e) => e.type == 'import');

    for (final toRemove in removeList) {
      final fullName = toRemove + '.dart';

      for (final constrainedValue in importList) {
        if (constrainedValue.type == 'import' &&
            fullName == constrainedValue.name) {
          constrainedValues.remove(constrainedValue);
          file = FileWriter.removeFromFile(constrainedValue, constrainedValues, file);
          break;
        }
      }
    }
  }

  void addImportToFile(dynamic importList, List<ConstrainedValue> constrainedValues) {
    for (final importToAdd in importList) {
      var name = "import '" + importToAdd + ".dart';\n";

      var tmp = ConstrainedValue(name, 0, name.length, 'import');

      file = FileWriter.addToFile(tmp, constrainedValues, file);
      constrainedValues.add(tmp);
    }
  }

}