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
                apiSecretKey: 'xxxx',
                // Callback URL for Twitter App
                // Android is a deeplink
                // iOS is a URLScheme
                redirectURI: 'URLScheme',
                // Forces the user to enter their credentials
                // to ensure the correct users account is authorized.
              );
              final authResult = await twitterLogin.login(forceLogin: true);
              switch (authResult.status) {
                case TwitterLoginStatus.loggedIn:
                  // success
                  break;
                case TwitterLoginStatus.cancelledByUser:
                  // cancel
                  break;
                case TwitterLoginStatus.error:
                  // error
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
