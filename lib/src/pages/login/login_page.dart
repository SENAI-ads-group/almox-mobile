import 'package:flutter/material.dart';
import 'package:almox_mobile/src/pages/login/login_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tecladoAberto = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/almox2.png',
                    height: tecladoAberto ? 70 : 150,
                    width: tecladoAberto ? 150 : 200,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ALMOX',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 190,
              width: MediaQuery.of(context).size.width - 40,
              child: Padding(
                padding: EdgeInsets.only(top: 190),
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LoginScreen(),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
