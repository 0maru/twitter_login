package com.maru.twitter_login;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChromeCustomTabManager implements MethodChannel.MethodCallHandler {

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

    }

    public void open(Activity activity, @NonNull String url, MethodChannel.Result result) {
        Intent intent = new Intent(activity, CustomTabActivity.class);
        activity.startActivity(intent);
        result.success(true);
        return;
    }
}
