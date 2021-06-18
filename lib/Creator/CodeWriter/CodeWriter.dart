import '../ConstrainedValue.dart';

abstract class CodeWriter {
  late String file;

  void exec(dynamic valueList, List<ConstrainedValue> constrainedValues,
      List<String> removeList, String file) {
    this.file = file;
    removeFromFile(removeList, constrainedValues);
    addToFile(valueList, constrainedValues);
  }

  void removeFromFile(List<String> removeList,
      List<ConstrainedValue> constrainedValues);

  void addToFile(dynamic valueList, List<ConstrainedValue> constrainedValues);
}