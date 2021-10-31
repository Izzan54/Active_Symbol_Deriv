// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:async';
// import 'dart:io';
import 'package:web_socket_channel/io.dart';
//import 'package:web_socket_channel/status.dart';

void main(List<String> arguments){
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
    await Future.delayed(Duration(seconds: 30), () { print(" Closing ${name}"); });
    channel.sink.close();
  });
  channel.sink.add('{"ticks": "R_50", "subscribe": 1}');
}
