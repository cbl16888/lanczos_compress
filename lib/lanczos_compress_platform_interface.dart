import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:typed_data';

import 'lanczos_compress_method_channel.dart';

abstract class LanczosCompressPlatform extends PlatformInterface {
  /// Constructs a LanczosCompressPlatform.
  LanczosCompressPlatform() : super(token: _token);

  static final Object _token = Object();

  static LanczosCompressPlatform _instance = MethodChannelLanczosCompress();

  /// The default instance of [LanczosCompressPlatform] to use.
  ///
  /// Defaults to [MethodChannelLanczosCompress].
  static LanczosCompressPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LanczosCompressPlatform] when
  /// they register themselves.
  static set instance(LanczosCompressPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  
  /// 压缩图片
  Future<Uint8List?> compressImage(
    Uint8List imageBytes, 
    int maxSize,
    {int quality = 80}
  ) {
    throw UnimplementedError('compressImage() has not been implemented.');
  }
}
