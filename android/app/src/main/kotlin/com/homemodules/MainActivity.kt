package com.homemodules

import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
// import com.homemodules.hmDevCtrlService
class MainActivity: FlutterActivity() {
    private val channel = "com.homemodules/device-controls";

    override fun configureFlutterEngine (@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger , channel).setMethodCallHandler {
            call, result -> 
            if (call.method == "getMessage") {
                val message = "Hi! I am fine";
                if (message.isNotEmpty()) {
                    result.success(message);
                } else {
                    result.error("UNAVAILABLE", "Something went wrong", null)
                }
            } else {
                result.notImplemented();
            }
        }
    }
}
