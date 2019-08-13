package com.yuzu.meiqia_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.meiqia.core.callback.OnInitCallback;
import com.meiqia.meiqiasdk.util.MQConfig;
import com.meiqia.meiqiasdk.util.MQIntentBuilder;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * MeiqiaPlugin
 */
public class MeiqiaPlugin implements MethodCallHandler {

    private static final String method_regiseter = "register";
    private static final String method_chat = "goToChat";

    private Activity mActivity;
    private MethodChannel mMethodChannel;

    private MeiqiaPlugin(Activity mActivity, MethodChannel channel) {
        this.mActivity = mActivity;
        this.mMethodChannel = channel;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "meiqia_plugin");

        channel.setMethodCallHandler(new MeiqiaPlugin(registrar.activity(), channel));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case method_regiseter:
                String appKey = call.argument("appKey");
                initMeiQiaSDK(mActivity, appKey, result);
                break;
            case method_chat:
                goToChat(call);
                break;
            case "11":
                break;
            default:
                result.notImplemented();
        }
    }

    private void initMeiQiaSDK(Context context, String appKey, final Result result) {
        Log.e("=========", "美洽 开始初始化");
        MQConfig.init(context, appKey, new OnInitCallback() {
            @Override
            public void onSuccess(final String s) {
                HashMap<String, Object> map = new HashMap<String, Object>() {
                    {
                        put("code", "1");
                        put("msg", s);
                    }
                };
                mMethodChannel.invokeMethod("initialResult", map);
                result.success("注册成功");
            }

            @Override
            public void onFailure(final int i, final String s) {
                HashMap<String, Object> map = new HashMap<String, Object>() {
                    {
                        put("code", String.valueOf(i));
                        put("msg", s);
                    }
                };
                mMethodChannel.invokeMethod("initialResult", map);
                result.error("注册失败", s, i);
            }
        });
    }

    private void goToChat(MethodCall call) {
        MQIntentBuilder builder = new MQIntentBuilder(mActivity);
        if (call.arguments != null) {
            if (call.hasArgument("userInfo")) {
                builder.setClientInfo((HashMap<String, String>) call.argument("userInfo"));
            }
            if (call.hasArgument("id")) {
                builder.setCustomizedId((String) call.argument("id"));
            }
        }
        Intent intent = builder.build();
        mActivity.startActivity(intent);
    }
}
