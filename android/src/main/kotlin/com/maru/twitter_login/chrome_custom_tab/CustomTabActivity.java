package com.maru.twitter_login.chrome_custom_tab;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.browser.customtabs.CustomTabsSession;

import com.maru.twitter_login.R;

import io.flutter.plugin.common.MethodChannel;

public class CustomTabActivity extends Activity {
    public CustomTabActivityHelper customTabActivityHelper;
    public CustomTabsSession customTabsSession;
    public CustomTabsIntent.Builder builder;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.chrome_custom_tab);

        final Bundle bundle = getIntent().getExtras();
        final String url = bundle.getString("url");
        final CustomTabActivity customTabActivity = this;

        customTabActivityHelper = new CustomTabActivityHelper();
        customTabActivityHelper.setConnectionCallback(new CustomTabActivityHelper.ConnectionCallback() {
            @Override
            public void onCustomTabsConnected() {
                customTabsSession = customTabActivityHelper.getSession();
                Uri uri = Uri.parse(url);
                customTabActivityHelper.mayLaunchUrl(uri, null, null);
                builder = new CustomTabsIntent.Builder(customTabsSession);
                CustomTabsIntent customTabsIntent = builder.build();
                CustomTabActivityHelper.openCustomTab(customTabActivity, customTabsIntent, uri);
            }

            @Override
            public void onCustomTabsDisconnected() {
                customTabActivity.close();
            }
        });
    }

    public void dispose(Activity activity, MethodChannel.Result result) {
        this.onStop();
        this.onDestroy();
        this.close();

        Intent intent = new Intent(activity, activity.getClass());
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        activity.startActivity(intent);
        result.success(true);
    }


    @Override
    protected void onStart() {
        super.onStart();
        customTabActivityHelper.bindCustomTabsService(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        customTabActivityHelper.unbindCustomTabsService(this);
    }

    public void close() {
        customTabsSession = null;
        finish();
    }
}
