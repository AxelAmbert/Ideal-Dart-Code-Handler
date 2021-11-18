import '../ConstrainedValue.dart';
import '../JsonData/FieldDeclarationData.dart';
import 'CodeWriter.dart';
import 'ConstraintEditor.dart';


class DeclarationWriter extends CodeWriter {
  DeclarationWriter(String file) : super(file);

  void removeFromFile(List<String> removeList, List<ConstrainedValue> constrainedValues) {

    final declarationList = constrainedValues.where((e) => e.type == 'declaration');

    for (final toRemove in removeList) {
      for (final constrainedValue in declarationList) {
        if (toRemove == constrainedValue.name) {
          constrainedValues.remove(constrainedValue);
          file = ConstraintEditor.removeFromFile(constrainedValue, constrainedValues, file);
          break;
        }
      }
    }
  }

  String getAFullDeclaration(FieldDeclarationData value) {
    var declaration = '\n\t' + value.code;

    addedData.add(value.name);
    if (value.children.isNotEmpty) {
      declaration += ' ';
      for (var i = 0; i < value.children.length; i++) {
        final sep = i + 1 < value.children.length ? ' ' : '\n';

        declaration += value.children[i].code + sep;
        addedData.add(value.children[i].name);
      }
    } else {
      declaration += '\n';
    }
    return (declaration);
  }

  void addToFile(List<FieldDeclarationData> fieldList, List<ConstrainedValue> constrainedValues) {

    for (final value in fieldList) {
      final start = findConstrainedStartOfClass(constrainedValues);
      final declaration = getAFullDeclaration(value);
      final constraint = ConstrainedValue(declaration, start, start + declaration.length, 'declaration');

      file = ConstraintEditor.addToFile(constraint, constrainedValues, file);
      constrainedValues.add(constraint);
    }
  }

}