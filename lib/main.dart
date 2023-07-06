import 'package:bitrix_chat/views/bitrixs_view/bitrix_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: BitrixView(),
    ),
  );
}
