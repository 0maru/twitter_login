import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// This class uses the [flutter_inappwebview].
class ChromeCustomTab extends ChromeSafariBrowser {
  /// Event fires when the [ChromeSafariBrowser] is closed.

  final Function? onClose;

  /// constructor
  ChromeCustomTab({
    this.onClose,
  }) : super();

  @override
  void onClosed() => onClose?.call();
}

class CustomInAppBrowser extends InAppBrowser {}
