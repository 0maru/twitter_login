package com.maru.twitter_login.chrome_custom_tab;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChromeCustomTabManager  {
    private static CustomTabActivity customTabActivity;

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
