package com.olgam.makingsentences;

import android.content.Intent;
import android.speech.tts.TextToSpeech;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private String CHANNEL = "com.olgam.makingsentences/install_language";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("installLanguage")) {
          installLanguage();
          result.success("Success");
        }
        else {
          result.notImplemented();
        }
      }
    });
  }

  private void installLanguage() {
    Intent installTTSIntent = new Intent();
    installTTSIntent.setAction(TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA);
    startActivity(installTTSIntent);
  }
}
