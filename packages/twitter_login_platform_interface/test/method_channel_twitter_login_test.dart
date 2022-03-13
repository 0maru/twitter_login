import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:twitter_login_platform_interface/twitter_login_platform_interface.dart';

void mani() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

class MethodChannelTwitterLoginMock extends Mock
    with MockPlatformInterfaceMixin
    implements MethodChannelTwitterLogin {}
