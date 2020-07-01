import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ChromeCustomTab extends ChromeSafariBrowser {
  final Function onClose;

  ChromeCustomTab({this.onClose});

  @override
  void onClosed() => onClose?.call();
}
