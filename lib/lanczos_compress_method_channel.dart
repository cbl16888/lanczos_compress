import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lanczos_compress_platform_interface.dart';

/// An implementation of [LanczosCompressPlatform] that uses method channels.
class MethodChannelLanczosCompress extends LanczosCompressPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('lanczos_compress');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  
  @override
  Future<Uint8List?> compressImage(
    Uint8List imageBytes, 
    int maxSize,
    {int quality = 80}
  ) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'compressImage',
      {
        'imageBytes': imageBytes,
        'maxSize': maxSize,
        'quality': quality,
      },
    );
    return result;
  }
}
