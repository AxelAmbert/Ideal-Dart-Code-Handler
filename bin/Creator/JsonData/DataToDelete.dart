class DataToDelete {
  List<String> imports = [];
  List<String> methods = [];
  List<String> declarations = [];

  DataToDelete.empty();

  DataToDelete(dynamic dataToDelete) {
    imports = dataToDelete['imports'];
    methods = dataToDelete['methods'];
    declarations = dataToDelete['declarations'];
  }

}