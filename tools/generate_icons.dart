import 'dart:io';
import 'package:path/path.dart' as path;

void main() async {
  // 定义不同尺寸的图标
  final Map<String, int> iconSizes = {
    'mdpi': 48,    // 1x
    'hdpi': 72,    // 1.5x
    'xhdpi': 96,   // 2x
    'xxhdpi': 144, // 3x
    'xxxhdpi': 192 // 4x
  };

  // 源SVG文件路径
  final String sourceSvgPath = path.join('assets', 'images', 'ic_launcher.svg');
  
  // 检查源文件是否存在
  if (!await File(sourceSvgPath).exists()) {
    print('错误：找不到源SVG文件：$sourceSvgPath');
    return;
  }

  // 为每个尺寸生成图标
  for (var entry in iconSizes.entries) {
    final String dpi = entry.key;
    final int size = entry.value;
    
    final String outputPath = path.join(
      'android', 
      'app', 
      'src', 
      'main', 
      'res', 
      'mipmap-$dpi',
      'ic_launcher.png'
    );

    // 使用Flutter的图标生成功能
    // 这里需要实现实际的图标生成逻辑
    print('生成 $dpi 图标 ($size x $size) 到: $outputPath');
  }
}
