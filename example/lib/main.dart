import 'package:flutter/material.dart';
import 'package:twitter_login/twitter_login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// TODO: sample code
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
              );
              final authResult = await twitterLogin.login();
              switch (authResult.status) {
                case TwitterLoginStatus.loggedIn:
                // success
                case TwitterLoginStatus.cancelledByUser:
                // cancel
                case TwitterLoginStatus.error:
                // error
              }
            },
          ),
        ),
      ),
    );
  }
}
