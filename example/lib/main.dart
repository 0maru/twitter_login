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
          child: FlatButton(
            child: Text('login'),
            onPressed: () async {
              final twitterLogin = TwitterLogin(
                // Consumer API keys
                apiKey: 'xxxx',
                // Consumer API Secret keys
                apiSecretKey: 'xxxx',
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
