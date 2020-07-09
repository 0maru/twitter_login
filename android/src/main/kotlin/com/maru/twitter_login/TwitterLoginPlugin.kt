package com.maru.twitter_login

import android.content.Intent

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import java.sql.DriverManager.println

/** TwitterLoginPlugin */
public class TwitterLoginPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var methodChannel : MethodChannel? = null
  private var eventChannel: EventChannel? = null
  private var eventSink: EventSink? = null
  private var activityPluginBinding: ActivityPluginBinding? = null
  private var scheme : String? = ""

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "twitter_login")
      TwitterLoginPlugin().onAttachedToEngine(registrar.messenger())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "setScheme") {
      scheme = call.arguments as String
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  fun onAttachedToEngine(messenger: BinaryMessenger) {
    methodChannel = MethodChannel(messenger, "twitter_login")
    methodChannel!!.setMethodCallHandler(this)

    eventChannel = EventChannel(messenger, "twitter_login/event")
    eventChannel!!.setStreamHandler(object: StreamHandler {
      override fun onListen(arguments: Any?, events: EventSink?) {
        eventSink = events!!
      }

      override fun onCancel(arguments: Any?) {
        eventSink = null
      }
    })
  }

  override fun onNewIntent(intent: Intent?): Boolean {
    if (scheme == intent!!.data?.scheme) {
      eventSink?.success(mapOf("type" to "url", "url" to intent!!.data?.toString()))
    }
    return true
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel!!.setMethodCallHandler(null)
    methodChannel = null

    eventChannel!!.setStreamHandler(null)
    eventChannel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivity() {
    activityPluginBinding?.removeOnNewIntentListener(this)
    activityPluginBinding = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityPluginBinding?.removeOnNewIntentListener(this)
    activityPluginBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityPluginBinding = binding
    binding.addOnNewIntentListener(this)
  }
}
