import 'package:flutter/cupertino.dart';

var api = {"url": "https://api.example.com", "key": "somerandomkey"};

void main() {
  // printの場合
  print(api);
  // debugPrintの場合
  debugPrint(api.toString());
}
