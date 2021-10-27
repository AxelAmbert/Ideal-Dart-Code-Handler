import 'dart:io';
import 'dart:typed_data';
import 'Indexer/DartCodeIndexer.dart';
import 'Indexer/MiscFunctions.dart';
import 'Creator/DartCodeViewWriter.dart';
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


  Future<void> handleNewMessage(dynamic parsedData) async {
    if (parsedData['requestType'] == 'index') {
      DartCodeIndexer(IndexerParameters(parsedData['parameters']), () {});
    } else if (parsedData['requestType'] == 'creator') {
      await DartCodeCreator(CreatorParameters(parsedData['parameters']), () {}).launchThreads();
    }
  }


  void main() async {
    final file = File(args[0]);
    var decoded = '';

    if (file.existsSync() == false) {
      throw Exception('File ${args[0]} does not exists');
    }
    decoded = file.readAsStringSync();
    print('Le code handler reçoit $decoded');
    await handleNewMessage(json.decode(decoded));
    file.deleteSync();
  }
}


void main(List<String> args) {
  Main(args);
}
