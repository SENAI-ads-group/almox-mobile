import 'package:almox_mobile/src/app.dart';
import 'package:almox_mobile/src/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:almox_mobile/src/routes/routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Color _primaryColor = Color.fromRGBO(0, 123, 255, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'ALMOX MOBILE',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: MaterialColor(
          _primaryColor.value,
          <int, Color>{
            50: Color(0xFFE3F2FD),
            100: Color(0xFFBBDEFB),
            200: Color(0xFF90CAF9),
            300: Color(0xFF64B5F6),
            400: Color(0xFF42A5F5),
            500: _primaryColor,
            600: Color(0xFF1E88E5),
            700: Color(0xFF1976D2),
            800: Color(0xFF1565C0),
            900: Color(0xFF0D47A1),
          },
        ),
      ),
      home: AppWidget(),
      routes: routes,
    );
  }
}
