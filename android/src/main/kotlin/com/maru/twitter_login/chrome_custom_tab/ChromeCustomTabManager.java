package com.maru.twitter_login.chrome_custom_tab;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChromeCustomTabManager implements MethodChannel.MethodCallHandler {
    private final Activity activity;
    private static CustomTabActivity customTabActivity;

    public ChromeCustomTabManager(BinaryMessenger messenger, Activity activity) {
        this.activity = activity;
        MethodChannel methodChannel = new MethodChannel(messenger, "twitter_login/auth_browser");
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if ("authentication".equals(call.method)) {
            final String url = call.argument("url");
            open(activity, url, result);
        } else if ("close".equals(call.method)) {
            close(activity, result);
        } else if ("isAvailable".equals(call.method)) {
            final boolean isAvailable = CustomTabActivityHelper.isAvailable(activity);
            result.success(isAvailable);
        } else {
            result.notImplemented();
        }
    }

    public void open(Activity activity, @NonNull String url, MethodChannel.Result result) {
        customTabActivity = new CustomTabActivity();
        if (!CustomTabActivityHelper.isAvailable(activity)) {
            result.error("ChromeCustomTabs", "is not available", null);
            return;
        }

        Bundle bundle = new Bundle();
        bundle.putString("fromActivity", activity.getClass().getName());
        bundle.putString("url", url);
        bundle.putBoolean("isData", false);
        Intent intent = new Intent(activity, customTabActivity.getClass());
        intent.putExtras(bundle);
        activity.startActivity(intent);
        result.success(true);
    }

    public void close(Activity activity, MethodChannel.Result result) {
        customTabActivity.dispose(activity, result);
    }
}
