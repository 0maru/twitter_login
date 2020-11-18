# twitter_login

![Pub Version](https://img.shields.io/pub/v/twitter_login?color=blue)

Flutter Twitter Login Plugin

# Requirements
- Dart sdk: ">=2.7.0 <3.0.0"
- Flutter: ">=1.10.0"
- Android: minSdkVersion 17 and add support for androidx
- iOS: --ios-language swift, Xcode version >= 11


## Twitter Configuration
[Twitter Developer](https://developer.twitter.com/)

required to create TwitterApp.
this plugin is need Callback URLs.

For example
```
example://
```

## Android Configuration

### Add intent filters for incoming links

[/example/android/app/src/main/AndroidManifest.xm](https://github.com/0maru/twitter_login/blob/master/example/android/app/src/main/AndroidManifest.xml)

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <!-- Accepts URIs that begin with "example://gizmos” -->
  <!-- Registered Callback URLs in TwitterApp -->
  <data android:scheme="example"
        android:host="gizmos" /> <!-- option -->
</intent-filter>
```



### Supporting the new Android plugins APIs

If you flutter created your project prior to version 1.12, you need to make sure to update your project in order to use the new Java Embedding API.
Make use you have flutter_embedding v2 enabled. Add the following code on the manifest file inside <application> tag to enable embedding.
Flutter wiki: [Upgrading pre 1.12 Android projects.](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```



## iOS Configuration

### Add URLScheme

[/example/ios/Runner/Info.plist](https://github.com/0maru/twitter_login/blob/master/example/ios/Runner/Info.plist#L21)

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <!-- Registered Callback URLs in TwitterApp -->
    <string>example</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>app</string>
    </array>
  </dict>
</array>
```

# Example code 

See the example directory for a complete sample app using twitter_login.

[example](https://github.com/0maru/twitter_login/tree/master/example)

# Usage

To use this plugin, add `twitter_login` as a [dependency in your pubspec.yaml file.](https://flutter.dev/platform-plugins/)

### Example

```dart
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
          title: const Text('Twitter Login App'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('Login With Twitter'),
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
              );
              final authResult = twitterLogin.login();
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
```
