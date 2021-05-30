package com.maru.twitter_login


import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.util.GeneratedPluginRegister
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry.NewIntentListener

/** TwitterLoginPlugin */
public class TwitterLoginPlugin : FlutterActivity(), FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {
    companion object {
        private const val CHANNEL = "twitter_login"
        private const val EVENT_CHANNEL = "twitter_login/event"
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventSink? = null
    private var activityPluginBinding: ActivityPluginBinding? = null
    private var scheme: String? = ""
    private lateinit var chromeCustomTabManager: ChromeCustomTabManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegister.registerGeneratedPlugins(flutterEngine)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when(call.method) {
            "setScheme" -> {
                scheme = call.arguments as String
                result.success(null)
            }
            "isAvailable" -> {
                val isAvailable = CustomTabActivityHelper.isAvailable(activity)
                result.success(isAvailable)
            }
            "authentication" -> {
                val url = call.arguments as String
                chromeCustomTabManager.open(activityPluginBinding?.activity, url, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun onAttachedToEngine(messenger: BinaryMessenger) {
        chromeCustomTabManager = ChromeCustomTabManager()
        methodChannel = MethodChannel(messenger, CHANNEL)
        methodChannel!!.setMethodCallHandler(this)

        eventChannel = EventChannel(messenger, EVENT_CHANNEL)
        eventChannel!!.setStreamHandler(object : StreamHandler {
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
            eventSink?.success(mapOf("type" to "url", "url" to intent.data?.toString()))
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
