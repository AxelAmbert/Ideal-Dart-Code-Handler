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

    if (args.length < 1) {
      print('Wrong number of argument, should at least be 1');
      print(args);
      return;
    }
    main();
  }


  void handleNewMessage(dynamic parsedData) {
    if (parsedData['requestType'] == 'index') {
      DartCodeIndexer(IndexerParameters(parsedData['parameters']), () {});
    } else if (parsedData['requestType'] == 'creator') {
      DartCodeCreator(CreatorParameters(parsedData['parameters']), () {});
    }
  }


  void main() async {
    final decoded = utf8.decode(base64Url.decode(args[0]));

    handleNewMessage(json.decode(decoded));
  }
}


void main(List<String> args) {
  Main(args);
}
