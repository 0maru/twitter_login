import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class ChromeSafariBrowserAlreadyOpenedException implements Exception {
  final dynamic message;

  ChromeSafariBrowserAlreadyOpenedException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "ChromeSafariBrowserAlreadyOpenedException";
    return "ChromeSafariBrowserAlreadyOpenedException: $message";
  }
}

class ChromeSafariBrowserNotOpenedException implements Exception {
  final dynamic message;

  ChromeSafariBrowserNotOpenedException([this.message]);

  String toString() {
    Object? message = this.message;
    if (message == null) return "ChromeSafariBrowserNotOpenedException";
    return "ChromeSafariBrowserNotOpenedException: $message";
  }
}

class ChromeSafariBrowser {
  ///View ID used internally.
  late final String id;

  Map<int, ChromeSafariBrowserMenuItem> _menuItems = new HashMap();
  bool _isOpened = false;
  late MethodChannel _channel;
  static const MethodChannel _sharedChannel = const MethodChannel('twitter_login/auth_browser');

  ChromeSafariBrowser() {
    id = IdGenerator.generate();
    this._channel = MethodChannel('twitter_login/auth_browser_$id');
    this._channel.setMethodCallHandler(handleMethod);
    _isOpened = false;
  }

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onChromeSafariBrowserOpened":
        onOpened();
        break;
      case "onChromeSafariBrowserCompletedInitialLoad":
        onCompletedInitialLoad();
        break;
      case "onChromeSafariBrowserClosed":
        onClosed();
        this._isOpened = false;
        break;
      case "onChromeSafariBrowserMenuItemActionPerform":
        String url = call.arguments["url"];
        String title = call.arguments["title"];
        int id = call.arguments["id"].toInt();
        if (this._menuItems[id] != null) {
          this._menuItems[id]!.action(url, title);
        }
        break;
      default:
        throw UnimplementedError("Unimplemented ${call.method} method");
    }
  }

  Future<void> open({required Uri url}) async {
    assert(url.toString().isNotEmpty);
    this.throwIsAlreadyOpened(message: 'Cannot open $url!');

    List<Map<String, dynamic>> menuItemList = [];
    _menuItems.forEach((key, value) {
      menuItemList.add({"id": value.id, "label": value.label});
    });

    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent('id', () => id);
    args.putIfAbsent('url', () => url.toString());
    args.putIfAbsent('options', () => {});
    args.putIfAbsent('menuItemList', () => menuItemList);
    await _sharedChannel.invokeMethod('open', args);
    this._isOpened = true;
  }

  ///Closes the [ChromeSafariBrowser] instance.
  Future<void> close() async {
    Map<String, dynamic> args = <String, dynamic>{};
    await _channel.invokeMethod("close", args);
  }

  ///Adds a [ChromeSafariBrowserMenuItem] to the menu.
  void addMenuItem(ChromeSafariBrowserMenuItem menuItem) {
    this._menuItems[menuItem.id] = menuItem;
  }

  ///Adds a list of [ChromeSafariBrowserMenuItem] to the menu.
  void addMenuItems(List<ChromeSafariBrowserMenuItem> menuItems) {
    menuItems.forEach((menuItem) {
      this._menuItems[menuItem.id] = menuItem;
    });
  }

  ///On Android, returns `true` if Chrome Custom Tabs is available.
  ///On iOS, returns `true` if SFSafariViewController is available.
  ///Otherwise returns `false`.
  static Future<bool> isAvailable() async {
    Map<String, dynamic> args = <String, dynamic>{};
    return await _sharedChannel.invokeMethod("isAvailable", args);
  }

  ///Event fires when the [ChromeSafariBrowser] is opened.
  void onOpened() {}

  ///Event fires when the initial URL load is complete.
  void onCompletedInitialLoad() {}

  ///Event fires when the [ChromeSafariBrowser] is closed.
  void onClosed() {}

  ///Returns `true` if the [ChromeSafariBrowser] instance is opened, otherwise `false`.
  bool isOpened() {
    return this._isOpened;
  }

  void throwIsAlreadyOpened({String message = ''}) {
    if (this.isOpened()) {
      throw ChromeSafariBrowserAlreadyOpenedException(
          ['Error: ${(message.isEmpty) ? '' : message + ' '}The browser is already opened.']);
    }
  }

  void throwIsNotOpened({String message = ''}) {
    if (!this.isOpened()) {
      throw ChromeSafariBrowserNotOpenedException(
          ['Error: ${(message.isEmpty) ? '' : message + ' '}The browser is not opened.']);
    }
  }
}

///Class that represents a custom menu item for a [ChromeSafariBrowser] instance.
class ChromeSafariBrowserMenuItem {
  ///The menu item id
  int id;

  ///The label of the menu item
  String label;

  ///Callback function to be invoked when the menu item is clicked
  final void Function(String url, String title) action;

  ChromeSafariBrowserMenuItem({required this.id, required this.label, required this.action});

  Map<String, dynamic> toMap() {
    return {"id": id, "label": label};
  }

  Map<String, dynamic> toJson() {
    return this.toMap();
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class IdGenerator {
  static int _count = 0;

  /// Math.Random()-based RNG. All platforms, fast, not cryptographically strong. Optional Seed passable.
  static Uint8List mathRNG({int seed = -1}) {
    var b = Uint8List(16);

    var rand = (seed == -1) ? Random() : Random(seed);

    for (var i = 0; i < 16; i++) {
      b[i] = rand.nextInt(256);
    }

    (seed == -1) ? b.shuffle() : b.shuffle(Random(seed));

    return b;
  }

  /// Crypto-Strong RNG. All platforms, unknown speed, cryptographically strong (theoretically)
  static Uint8List cryptoRNG() {
    var b = Uint8List(16);
    var rand = Random.secure();
    for (var i = 0; i < 16; i++) {
      b[i] = rand.nextInt(256);
    }
    return b;
  }

  static String generate() {
    _count++;
    return _count.toString() + cryptoRNG().map((e) => e.toString()).join('');
  }
}
