# twitter_login

![Pub Version](https://img.shields.io/pub/v/twitter_login?color=blue)

Flutter Twitter Login Plugin

# Requirements
- Dart sdk: ">=2.7.0 <3.0.0"
- Flutter: ">=1.10.0"
- Android: minSdkVersion 17 and add support for androidx
- iOS: --ios-language swift, Xcode version >= 11

# Example code 

See the example directory for a complete sample app using twitter_login.

[example](https://github.com/0maru/twitter_login/tree/master/example)

# Usage

To use this plugin, add `twitter_login` as a [dependency in your pubspec.yaml file.](https://flutter.dev/platform-plugins/)

### Example

```
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
              );
              final authResult = twitterLogin.login();
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
```

