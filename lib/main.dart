import 'package:almox_mobile/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ALMOX',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: routes,
    );
  }
}
