import 'package:flutter/material.dart';
import 'package:flutter_course/tst.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tst(),
      debugShowCheckedModeBanner: false,
      routes: {
        "Test": (context) => Tst(),
      },
    );
  }
}
