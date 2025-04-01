import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:lanczos_compress/lanczos_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _lanczosCompressPlugin = LanczosCompress();
  File? _image;
  File? _compressedImage;
  bool _isCompressing = false;
  String _compressionInfo = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _lanczosCompressPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _compressedImage = null;
        _compressionInfo = '';
      });
    }
  }

  Future<void> _compressImage() async {
    if (_image == null) return;

    setState(() {
      _isCompressing = true;
    });

    try {
      final int originalSize = await _image!.length();
      final Uint8List imageBytes = await _image!.readAsBytes();

      // 获取图片尺寸
      final decodedImage = await decodeImageFromList(imageBytes);
      final int originalWidth = decodedImage.width;
      final int originalHeight = decodedImage.height;

      // 计算新尺寸，保持宽高比
      var maxSize = 400;
      int targetWidth;
      int targetHeight;
      if (originalWidth > originalHeight) {
        targetWidth = 400;
        targetHeight = (targetWidth * originalHeight / originalWidth).round();
      } else {
        targetHeight = 400;
        targetWidth = (targetHeight * originalWidth / originalHeight).round();
      }

      // 压缩图片
      final startTime = DateTime.now();
      final Uint8List? compressedBytes = await _lanczosCompressPlugin.compressImage(
        imageBytes,
        maxSize,
        quality: 75
      );
      final endTime = DateTime.now();

      if (compressedBytes != null) {
        // 保存压缩后的图片
        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/compressed_image_$startTime.jpg';
        final compressedFile = File(tempPath);
        await compressedFile.writeAsBytes(compressedBytes);

        final int compressedSize = compressedBytes.length;
        final double compressionRatio = originalSize / compressedSize;
        final int processingTime = endTime.difference(startTime).inMilliseconds;

        setState(() {
          _compressedImage = compressedFile;
          _compressionInfo = 'Original: ${(originalSize / 1024).toStringAsFixed(2)} KB '
              '($originalWidth x $originalHeight)\n'
              'Compressed: ${(compressedSize / 1024).toStringAsFixed(2)} KB '
              '($targetWidth x $targetHeight)\n'
              'Ratio: ${compressionRatio.toStringAsFixed(2)}x\n'
              'Time: $processingTime ms';
        });
      }
    } catch (e) {
      setState(() {
        _compressionInfo = 'Error: $e';
      });
    } finally {
      setState(() {
        _isCompressing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lanczos Compress Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Running on: $_platformVersion\n'),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(height: 16),
                  if (_image != null) ...[
                    Text('Original Image:'),
                    Image.file(_image!, height: 200),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isCompressing ? null : _compressImage,
                      child: _isCompressing
                          ? const CircularProgressIndicator()
                          : const Text('Compress Image'),
                    ),
                  ],
                  if (_compressionInfo.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(_compressionInfo),
                  ],
                  if (_compressedImage != null) ...[
                    const SizedBox(height: 16),
                    Text('Compressed Image:'),
                    Image.file(_compressedImage!, height: 200),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
