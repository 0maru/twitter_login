import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_login/twitter_login_method_channel.dart';

void main() {
  MethodChannelTwitterLogin platform = MethodChannelTwitterLogin();
  const MethodChannel channel = MethodChannel('twitter_login');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
