class DataToDelete {
  List<String> imports = [];
  List<String> methods = [];
  List<String> declarations = [];

  DataToDelete.empty();

  DataToDelete(dynamic dataToDelete) {
    imports = dataToDelete['imports'].cast<String>();
    methods = dataToDelete['methods'].cast<String>();
    declarations = dataToDelete['declarations'].cast<String>();
  }

}