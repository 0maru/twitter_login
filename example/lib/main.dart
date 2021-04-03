import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';

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
        body: Center(
          child: TextButton(
            child: Text('login'),
            onPressed: () async {
              final twitterLogin = TwitterLogin(
                // Consumer API keys
                apiKey: 'xxx',
                // Consumer API Secret keys
                apiSecretKey: 'xxxxx',
                // Registered Callback URLs in TwitterApp
                // Android is a deeplink
                // iOS is a URLScheme
                redirectURI: 'example://',
                // Forces the user to enter their credentials
                // to ensure the correct users account is authorized.
              );
              // If you want to implement Twitter account switching, set [force_login] to true
              // login(forceLogin: true);
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
            },
          ),
        ),
      ),
    );
  }
}
