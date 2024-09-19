package com.esmart;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Build;
import android.Manifest;
import android.content.Context;

import androidx.annotation.Nullable;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.isbc.libesmartvirtualcard.external.IntentActions;
import com.isbc.libesmartvirtualcard.external.LibEsmartVirtualCard;
import com.isbc.libesmartvirtualcard.external.LibraryDelegate;
import com.isbc.libesmartvirtualcard.external.CardMode;

// import org.apache.cordova.CallbackContext;
// import org.apache.cordova.CordovaPlugin;
// import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;


import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
// https://stackoverflow.com/questions/48056126/pass-java-object-to-react-native-component-and-vice-versa
// https://stackoverflow.com/questions/46125406/how-to-pass-an-object-back-from-a-react-native-android-module-to-javascript
// https://medium.com/shoutem/ways-to-pass-objects-between-native-and-javascript-in-react-native-c3dcae7bf4f5
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

import java.util.Map;
import java.util.HashMap;

import android.util.Log;

/**
 * This class echoes a string called from JavaScript.
 */
public class EsmartModule extends ReactContextBaseJavaModule implements LibraryDelegate {
    public String getName() {
        return "Esmart";
    }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    public void multiply(double a, double b, Promise promise) {
        promise.resolve(a * b);
    }

    // custom code

    @ReactMethod
    public void bleServiceEvent(Promise promise) {
        promise.resolve(IntentActions.BLE_SERVICE_EVENT);
    }

    private Context context;

    EsmartModule(ReactApplicationContext context) {
        super(context);
        this.context = context.getApplicationContext(); // This is where you get the context
    }

    @Override
    public void onLibraryInitFinish() {
        Log.d("onLibraryInitFinish", "onLibraryInitFinish");
    }

    @Override
    public void onLibraryInitWarning(int code) {
        Log.d("onLibraryInitWarning", "code: " + code);

        String warning = createInitialConstantByValue(code);

        if (code == LibEsmartVirtualCard.WARNING_BLUETOOTH_PERMISSION_MISSED) {
            Log.d("onLibraryInitWarning", "warning: " + warning);
        }
    }

    @Override
    public void onLibraryInitFailed(int code) {
        Log.d("onLibraryInitFailed", "code: " + code);
        String errorObject = createInitialConstantByValue(code);
        if (errorObject == null) {
            Log.d("onLibraryInitFailed", "errorObject: null");
        } else {
            Log.d("onLibraryInitFailed", "errorObject: " + errorObject);
        }
    }

    @Override
    public Context getApplicationContext() {
        return this.context;
    }

    @ReactMethod
    public void init(Promise promise) {
        LibEsmartVirtualCard.init(this);
        promise.resolve(true);
    }

    @ReactMethod
    public void shutdown(Promise promise) {
        LibEsmartVirtualCard.shutdown();
        promise.resolve(true);
    }

    @ReactMethod
    public void getCardMode(Promise promise) {
        CardMode cardMode = LibEsmartVirtualCard.getCardMode();

        WritableMap map = Arguments.createMap();
        map.putInt("result", cardMode.ordinal());
        promise.resolve(map);
    }

    @ReactMethod
    public void setCardMode(int cardModeValue, Promise promise) {
        CardMode cardMode = CardMode.valueOf(cardModeValue);
        LibEsmartVirtualCard.setCardMode(cardMode);
        promise.resolve(cardModeValue);
    }

    private String createInitialConstantByValue(int value) {
        String constantName = null;
        switch (value) {
            case LibEsmartVirtualCard.FAILURE_BLE_NOT_SUPPORTED: constantName = "FAILURE_BLE_NOT_SUPPORTED"; break;
            case LibEsmartVirtualCard.FAILURE_HCE_NOT_SUPPORTED: constantName = "FAILURE_HCE_NOT_SUPPORTED"; break;
            case LibEsmartVirtualCard.FAILURE_NO: constantName = "FAILURE_NO"; break;
            case LibEsmartVirtualCard.FAILURE_PERMISSION_REQUIRED: constantName = "FAILURE_PERMISSION_REQUIRED"; break;
            case LibEsmartVirtualCard.FAILURE_PIN_REQUIRED: constantName = "FAILURE_PIN_REQUIRED"; break;
            case LibEsmartVirtualCard.FAILURE_PIN_WRONG: constantName = "FAILURE_PIN_WRONG"; break;
            case LibEsmartVirtualCard.WARNING_BLUETOOTH_PERMISSION_MISSED: constantName = "WARNING_BLUETOOTH_PERMISSION_MISSED"; break;
            case LibEsmartVirtualCard.WARNING_NFC_PERMISSION_MISSED: constantName = "WARNING_NFC_PERMISSION_MISSED"; break;
        }

        return constantName;
    }
}
