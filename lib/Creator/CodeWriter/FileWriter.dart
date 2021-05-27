import '../ConstrainedValue.dart';

class FileWriter {
  static String removeFromFile(ConstrainedValue toRemove,
      List<ConstrainedValue> constrainedValues, String file) {
    file = file.substring(0, toRemove.begin) + file.substring(toRemove.end);

    constrainedValues.forEach((constrainedValue) {
      constrainedValue.recomputeConstraint(toRemove, (a, b) => a - b);
    });
    return (file);
  }

  static String addToFile(ConstrainedValue toAdd, List<ConstrainedValue> constrainedValues, String file) {
    file = file.substring(0, toAdd.begin) + toAdd.name + file.substring(toAdd.begin);

    constrainedValues.forEach((constrainedValue) {
      constrainedValue.recomputeConstraint(toAdd, (a, b) => a + b);
    });
    return (file);
  }

}
