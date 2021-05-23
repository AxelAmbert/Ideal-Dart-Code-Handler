import 'dart:io';
import 'dart:typed_data';
import 'Indexer/CodeLinkIndexer.dart';
import 'Indexer/MiscFunctions.dart';
import 'dart:convert';

class Main {
  var server;
  var idealFolderPath;
  var fullPath;

  Main() {
    main();
  }

  void sendResponse() {

  }

  void handleNewMessage(dynamic parsedData) {
    if (parsedData['request-type'] == 'index') {
      Index(fullPath, parsedData['parameters'], () {});
    }
  }


  void onNewMessage(Uint8List data, Socket client) async {
    final message = String.fromCharCodes(data);
    var parsedData;

    try {
      parsedData = json.decode(message);
      handleNewMessage(parsedData);
    } catch (e) {
      print('Invalid message');
      print(e.toString());
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

  List<String> chooseFolderName() {
    if (Platform.isWindows) {
      return ([r'C:\Program Files', 'Ideal']);
    } else if (Platform.isLinux) {
      return (['~/home', '.Ideal']);
    } else if (Platform.isMacOS) {
      //return (forMacOS());
    }
    throw Exception('Invalid platform');
  }

  void main() async {
    idealFolderPath = chooseFolderName();

    if (idealFolderPath.isEmpty) {
      print('Unrecognised platform, the server will stop.');
      return;
    }
    createDirectory(idealFolderPath[0], idealFolderPath[1]);
    fullPath = idealFolderPath[0] + Platform.pathSeparator + idealFolderPath[1];
    server = await ServerSocket.bind(InternetAddress.anyIPv4, 41081);
    server.listen((client) {
      handleConnection(client);
    });
  }
}


void main() async {
  Main();
}
