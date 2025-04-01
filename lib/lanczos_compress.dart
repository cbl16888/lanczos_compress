import 'dart:typed_data';
import 'lanczos_compress_platform_interface.dart';

class LanczosCompress {
  Future<String?> getPlatformVersion() {
    return LanczosCompressPlatform.instance.getPlatformVersion();
  }

  /// 压缩图片
  /// [imageBytes] 原始图片字节数据
  /// [width] 目标宽度
  /// [height] 目标高度
  /// [quality] 压缩质量 (0-100)
  /// 返回压缩后的图片字节数据
  Future<Uint8List?> compressImage(Uint8List imageBytes, int maxSize, {int quality = 80}) {
    return LanczosCompressPlatform.instance.compressImage(imageBytes, maxSize, quality: quality);
  }
}
