import Flutter
import UIKit
import Resizer

public class LanczosCompressPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lanczos_compress", binaryMessenger: registrar.messenger())
    let instance = LanczosCompressPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "compressImage":
      guard let args = call.arguments as? [String: Any],
            let imageBytes = args["imageBytes"] as? FlutterStandardTypedData,
            let maxSize = args["maxSize"] as? Int,
            let quality = args["quality"] as? Int else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
        return
      }
      
      do {
        let compressedData = try compressImage(imageBytes.data, maxSize: maxSize, quality: quality)
        result(FlutterStandardTypedData(bytes: compressedData))
      } catch {
        result(FlutterError(code: "COMPRESSION_ERROR", message: error.localizedDescription, details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func compressImage(_ imageData: Data, maxSize: Int, quality: Int) throws -> Data {
      // 使用Resizer框架调整图片大小
      return ResizerResizeImage(imageData, maxSize, quality, nil) ?? Data()
  }
}
