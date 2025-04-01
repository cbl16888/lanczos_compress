import 'package:flutter_test/flutter_test.dart';
import 'package:lanczos_compress/lanczos_compress.dart';
import 'package:lanczos_compress/lanczos_compress_platform_interface.dart';
import 'package:lanczos_compress/lanczos_compress_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLanczosCompressPlatform
    with MockPlatformInterfaceMixin
    implements LanczosCompressPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LanczosCompressPlatform initialPlatform = LanczosCompressPlatform.instance;

  test('$MethodChannelLanczosCompress is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLanczosCompress>());
  });

  test('getPlatformVersion', () async {
    LanczosCompress lanczosCompressPlugin = LanczosCompress();
    MockLanczosCompressPlatform fakePlatform = MockLanczosCompressPlatform();
    LanczosCompressPlatform.instance = fakePlatform;

    expect(await lanczosCompressPlugin.getPlatformVersion(), '42');
  });
}
