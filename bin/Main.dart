import 'dart:io';
import 'dart:typed_data';
import 'Indexer/DartCodeIndexer.dart';
import 'Indexer/MiscFunctions.dart';
import 'Creator/DartCodeCreator.dart';
import 'Indexer/JsonData/IndexerParameters.dart';
import 'Creator/JsonData/CreatorParameters.dart';

import 'dart:convert';

class Main {
  List<String> args;

  Main(this.args) {

    if (args.length != 2) {
      print('Wrong number of argument, found ${args.length} instead of 2');
      return;
    }
    main();
  }

  void sendResponse() {

  }

  void handleNewMessage(String type, dynamic parsedData) {
    if (parsedData['requestType'] == 'index') {
      DartCodeIndexer(IndexerParameters(parsedData['parameters']), () {});
    } else if (parsedData['requestType'] == 'creator') {
      DartCodeCreator(CreatorParameters(parsedData['parameters']), () {});
    }
  }


  void main() async {
    final type = args[0];
    final parsedData = json.decode(args[1]);

    handleNewMessage(type, parsedData);
  }
}


void main(List<String> args) async {
  Main(args);
}
