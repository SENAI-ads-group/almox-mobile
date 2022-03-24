import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/home/home_page.dart';
import 'package:almox_mobile/src/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALMOX',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      routes: routes,
    );
  }
}
