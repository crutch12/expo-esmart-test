package com.esmart

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

import com.isbc.libesmartvirtualcard.external.IntentActions;

class EsmartModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  fun multiply(a: Double, b: Double, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun bleServiceEvent(promise: Promise) {
    promise.resolve(IntentActions.BLE_SERVICE_EVENT)
  }

  companion object {
    const val NAME = "Esmart"
  }
}
