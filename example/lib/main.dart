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
  final String apiKey = 'S9GzajUq5r5V4VIvT0V0M1HrP';
  final String apiSecretKey = 'U6NhHZxqRahi2StQYLz6mVhMZEow1HsaZ6igkNgJa47dfQ4fhI';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('twitter_login example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              const Text(
                'Twitter API v1.1 is not available when creating a new application in twitter developer from November 15, 2021.\n'
                'Check the Twitter Developer to see if it supports v1.1 or v2.',
              ),
              const SizedBox(height: 24),
              Image.asset(
                'assets/twitter_dashboard.png',
                width: double.infinity,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  child: const Text('use Twitter API v1.1'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(160, 48)),
                  ),
                  onPressed: () async {
                    await login();
                  },
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  child: const Text('use Twitter API v2.0'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                    minimumSize: MaterialStateProperty.all<Size>(const Size(160, 48)),
                  ),
                  onPressed: () async {
                    await loginV2();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Use Twitter API v1.1
  Future login() async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: apiKey,

      /// Consumer API Secret keys
      apiSecretKey: apiSecretKey,

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
        print(authResult.authToken);
        print(authResult.authTokenSecret);
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

  /// Use Twitter API v2.
  Future loginV2() async {
    final twitterLogin = TwitterLogin(
      /// Consumer API keys
      apiKey: apiKey,

      /// Consumer API Secret keys
      apiSecretKey: apiSecretKey,

      /// Registered Callback URLs in TwitterApp
      /// Android is a deeplink
      /// iOS is a URLScheme
      redirectURI: 'example://',
    );

    /// Forces the user to enter their credentials
    /// to ensure the correct users account is authorized.
    /// If you want to implement Twitter account switching, set [force_login] to true
    /// login(forceLogin: true);
    final authResult = await twitterLogin.loginV2();
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
