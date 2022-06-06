package com.maru.twitter_login.chrome_custom_tabs;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.maru.twitter_login.TwitterLoginPlugin;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChromeSafariBrowserManager implements MethodChannel.MethodCallHandler {
    public MethodChannel channel;
    public TwitterLoginPlugin plugin;
    public String id;
    public static final Map<String, ChromeSafariBrowserManager> shared = new HashMap<>();

    public ChromeSafariBrowserManager(@NonNull final TwitterLoginPlugin plugin) {
        this.id = UUID.randomUUID().toString();
        this.plugin = plugin;
        channel = new MethodChannel(Objects.requireNonNull(plugin.getMessenger()), "twitter_login/auth_browser");
        channel.setMethodCallHandler(this);
        shared.put(this.id, this);
    }

    @Override
    public void onMethodCall(final MethodCall call, @NotNull final MethodChannel.Result result) {
        if ("open".equals(call.method)) {
            final String id = (String) call.argument("id");
            String url = (String) call.argument("url");
            open(plugin.getPluginActivity(), id, url, result);
        } else if ("isAvailable".equals(call.method)) {
            result.success(CustomTabActivityHelper.isAvailable(plugin.getPluginActivity()));
        } else {
            result.notImplemented();
        }
    }

    public void open(Activity activity, String id, String url, MethodChannel.Result result) {
        if (!CustomTabActivityHelper.isAvailable(activity)) {
            result.error(
                    "CAN_NOT_LUNCH",
                    "Not installed a browser that supports custom tabs.",
                    "");
            return;
        }

        Bundle extras = new Bundle();
        extras.putString("url", url);
        extras.putString("id", id);
        extras.putString("managerId", this.id);
        Intent intent = new Intent(activity, ChromeCustomTabsActivity.class);
        intent.putExtras(extras);
        activity.startActivity(intent);
        result.success(true);
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
        shared.remove(this.id);
        plugin = null;
    }
}
