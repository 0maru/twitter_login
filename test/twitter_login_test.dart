import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_login/twitter_login.dart';

void main() {
  const MethodChannel channel = MethodChannel('twitter_login');

  TestWidgetsFlutterBinding.ensureInitialized();
}
