import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:twitter_login_example/env.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                child: Text('login'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                  minimumSize: MaterialStateProperty.all<Size>(Size(160, 48)),
                ),
                onPressed: () async {
                  await login();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future login() async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: API_KEY,

      /// Consumer API Secret keys
      apiSecretKey: API_SECRET_KEY,

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'example://',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.login();
    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        // success
        print('====== Login success ======');
        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('====== Login cancel ======');
        break;
      case TwitterLoginStatus.error:
      case null:
        // error
        print('====== Login error ======');
        break;
    }
  }
}
