package com.example.clean_machine

import android.os.Bundle
import android.os.Environment
import android.os.StatFs
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.clean_machine/deviceinfo"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getDiskSpace") {
                try {
                    val stat = StatFs(Environment.getDataDirectory().path)
                    val totalBytes = stat.totalBytes
                    val freeBytes = stat.availableBytes
                    val totalMB = totalBytes / (1024 * 1024)
                    val freeMB = freeBytes / (1024 * 1024)

                    val data = mapOf("total" to totalMB, "free" to freeMB)
                    result.success(data)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Disk info not available", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
