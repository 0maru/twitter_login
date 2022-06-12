package com.maru.twitter_login.chrome_custom_tabs;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsSession;

import com.maru.twitter_login.R;
import com.maru.twitter_login.customtabsclient.CustomTabsHelper;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ChromeCustomTabsActivity extends Activity implements MethodChannel.MethodCallHandler {

    public MethodChannel channel;
    public String id;
    public CustomTabsIntent.Builder builder;
    public CustomTabActivityHelper helper;
    public CustomTabsSession session;
    public ChromeSafariBrowserManager manager;
    protected final int CHROME_CUSTOM_TAB_REQUEST_CODE = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.chrome_custom_tab);

        Bundle bundle = getIntent().getExtras();
        assert bundle != null;

        String managerId = bundle.getString("managerId");
        manager = ChromeSafariBrowserManager.shared.get(managerId);

        // Create a methodChannel for each Activity.
        id = bundle.getString("id");
        channel = new MethodChannel(manager.plugin.getMessenger(), "twitter_login/auth_browser_" + id);
        channel.setMethodCallHandler(this);

        final String url = bundle.getString("url");

        final ChromeCustomTabsActivity chromeCustomTabsActivity = this;

        helper = new CustomTabActivityHelper();
        helper.setConnectionCallback(new CustomTabActivityHelper.ConnectionCallback() {
            @Override
            public void onCustomTabsConnected() {
                session = helper.getSession();
                Uri uri = Uri.parse(url);
                helper.mayLaunchUrl(uri, null, null);
                builder = new CustomTabsIntent.Builder(session);
                CustomTabsIntent customTabsIntent = builder.build();
                prepareCustomTabsIntent(customTabsIntent);
                CustomTabActivityHelper.openCustomTab(
                        chromeCustomTabsActivity,
                        customTabsIntent,
                        uri,
                        CHROME_CUSTOM_TAB_REQUEST_CODE
                );
            }

            @Override
            public void onCustomTabsDisconnected() {
                chromeCustomTabsActivity.close();
                dispose();
            }
        });
    }

    @Override
    public void onMethodCall(final MethodCall call, @NotNull final MethodChannel.Result result) {
        // invokeMethod is defined to pass the cancelled operation to the Dart side.
    }


    private void prepareCustomTabsIntent(CustomTabsIntent customTabsIntent) {
        customTabsIntent.intent.setPackage(CustomTabsHelper.getPackageNameToUse(this));
        CustomTabsHelper.addKeepAliveExtra(this, customTabsIntent.intent);
    }

    @Override
    protected void onStart() {
        super.onStart();
        helper.bindCustomTabsService(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        helper.unbindCustomTabsService(this);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CHROME_CUSTOM_TAB_REQUEST_CODE) {
            close();
            dispose();
        }
    }

    public void dispose() {
        channel.setMethodCallHandler(null);
        manager = null;
    }

    public void close() {
        session = null;
        finish();
        Map<String, Object> obj = new HashMap<>();
        channel.invokeMethod("onClose", obj);
    }
}
