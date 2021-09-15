import 'dart:io';
import 'dart:typed_data';
import 'Indexer/DartCodeIndexer.dart';
import 'Indexer/MiscFunctions.dart';
import 'Creator/DartCodeCreator.dart';
import 'Indexer/JsonData/IndexerParameters.dart';
import 'Creator/JsonData/CreatorParameters.dart';

import 'dart:convert';

class Main {
  var server;
  final port = 41081;

  Main() {
    main();
  }

  void sendResponse() {

  }

  void handleNewMessage(dynamic parsedData) {
    if (parsedData['requestType'] == 'index') {
      DartCodeIndexer(IndexerParameters(parsedData['parameters']), () {});
    } else if (parsedData['requestType'] == 'creator') {
      DartCodeCreator(CreatorParameters(parsedData['parameters']), () {});
    }
  }


  void onNewMessage(Uint8List data, Socket client) async {
    final message = String.fromCharCodes(data);
    var parsedData;

    print('The server receive: $message');
    try {
      client.write(jsonEncode({'info': 'message received'}));
      parsedData = json.decode(message);
      handleNewMessage(parsedData);
    } catch (e, stack) {
      print('Invalid message');
      print(e.toString());
      print(stack.toString());
    }
  }

  void handleConnection(Socket client) {
    print('Connection: ${client.remoteAddress.address}:${client.remotePort}');
    client.listen(
      (Uint8List data) {
        onNewMessage(data, client);
      },
      onError: (error) {
        print(error);
        client.close();
      },
      onDone: () {
        print('Client left');
        client.close();
      },
    );
  }

  void main() async {
    server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server started on port ${port}');
    server.listen((client) {
      handleConnection(client);
    });
  }
}


void main() async {
  Main();
}
