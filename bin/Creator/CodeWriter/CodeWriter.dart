import '../ConstrainedValue.dart';

class CodeWriter {
  String file = '';
  List<String> addedData = [];

  CodeWriter(String file) {
    this.file = file;
  }

  /*void exec(dynamic valueList, List<ConstrainedValue> constrainedValues,
      List<String> removeList, String file) {
    this.file = file;
    removeFromFile(removeList, constrainedValues);
    addToFile(valueList, constrainedValues);
  }*/

  int findConstrainedStartOfClass(List<ConstrainedValue> constrainedValues) {
    for (final constrainedValue in constrainedValues) {
      if (constrainedValue.type == 'start-class') {
        return (constrainedValue.begin);
      }
    }
    throw Exception('Start class not found');
  }

}