// ignore_for_file: unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/io.dart';

void main(List<String> arguments) {
  final channel = IOWebSocketChannel.connect(
      'wss://ws.binaryws.com/websockets/v3?app_id=1089');

  channel.stream.listen((activeSymbol) {
    final decodeList = jsonDecode(activeSymbol);
    final nameSymbol = decodeList['active_symbols'];

    dynamic symbol;

    for (var i = 0; i < 78; i++) {
      symbol = nameSymbol[i]['symbol'];
      print("List of symbol: ${symbol}");
    }

    listActive();
    channel.sink.close();
  });

  channel.sink.add('{"active_symbols": "brief"}');
}

void listActive() {
  final channel = IOWebSocketChannel.connect(
      'wss://ws.binaryws.com/websockets/v3?app_id=1089');

  channel.stream.listen((tick) async {
    final decodeSymbol = jsonDecode(tick);
    final name = decodeSymbol['tick']['symbol'];
    final price = decodeSymbol['tick']['quote'];
    final time = decodeSymbol['tick']['epoch'];
    final serverTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    print("Name: ${name}, Price: ${price}, TimeDate: ${serverTime}");

    //closing channel after 30 seconds
    await Future.delayed(Duration(seconds: 30), () {
      print(" Closing ${name}");
    });
    channel.sink.close();
  });
  print('Please Enter Symbol Name : ');
  final userInput = stdin.readLineSync();
  channel.sink.add('{"ticks":"$userInput"}');
}
