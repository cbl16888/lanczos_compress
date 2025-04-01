package com.aewt.app.lanczos.lanczos_compress

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import resizer.Resizer
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream

/** LanczosCompressPlugin */
class LanczosCompressPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "lanczos_compress")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "compressImage" -> {
        try {
          val imageBytes = call.argument<ByteArray>("imageBytes")
          val maxSize = call.argument<Int>("maxSize") ?: 0
          val quality = call.argument<Int>("quality") ?: 80
          
          if (imageBytes == null || maxSize <= 0) {
            result.error("INVALID_ARGUMENT", "Invalid arguments", null)
            return
          }
          
          val compressedBytes = compressImage(imageBytes, maxSize.toLong(), quality.toLong())
          result.success(compressedBytes)
        } catch (e: Exception) {
          result.error("COMPRESSION_ERROR", e.message, e.stackTraceToString())
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun compressImage(imageBytes: ByteArray, maxSize: Long, quality: Long): ByteArray {
    return Resizer.resizeImage(imageBytes, maxSize, quality)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
