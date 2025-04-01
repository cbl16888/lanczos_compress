# lanczos_compress

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

iOS集成过程
步骤 1：将 Resizer.xcframework 添加到插件的 ios/Frameworks/
在 my_plugin/ios/Frameworks/ 目录下放入 Resizer.xcframework，目录结构如下：
my_plugin/
├── ios/
│   ├── Frameworks/
│   │   ├── Resizer.xcframework/
│   ├── my_plugin.podspec
│   ├── Classes/
│   │   ├── MyPlugin.swift

步骤 2：修改 my_plugin.podspec
在 my_plugin/ios/my_plugin.podspec 文件中，添加 vendored_frameworks 配置：
Pod::Spec.new do |s|
s.name             = 'my_plugin'
s.version          = '0.0.1'
s.summary          = 'A Flutter plugin for Resizer framework'
s.description      = 'A Flutter plugin for Resizer framework'
s.homepage         = 'https://your-plugin-homepage.com'
s.license          = { :file => '../LICENSE' }
s.author           = { 'Your Name' => 'your_email@example.com' }
s.source           = { :path => '.' }
s.platform         = :ios, '12.0'  # 适配 iOS 12.0 及以上
s.source_files     = 'Classes/**/*'
s.vendored_frameworks = 'Frameworks/Resizer.xcframework' # 引入 Resizer.framework
s.dependency 'Flutter'
end

步骤 3：修改 MyPlugin.swift 并调用 Resizer.framework
打开 ios/Classes/MyPlugin.swift，添加：

import Flutter
import UIKit
import Resizer  // 确保 Resizer.framework 已正确导入

// 使用Resizer框架里的方法调整图片大小
ResizerResizeImage(imageData, maxSize, quality, nil) ?? Data()

Android 集成过程
