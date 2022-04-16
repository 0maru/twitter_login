package com.maru.twitter_login.customtabsclient

import android.app.Activity
import android.os.Bundle

class CallbackActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val url = intent?.data
        val scheme = url?.scheme

        if (scheme != null) {
            println(scheme)
        }

        finish()
    }
}