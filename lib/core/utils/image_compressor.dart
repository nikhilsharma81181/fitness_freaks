import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Utility class for compressing images before upload
class ImageCompressor {
  /// Compress an image file
  ///
  /// [file] is the image file to compress
  /// [quality] is the compression quality (0-100)
  /// [maxWidth] is the maximum width of the resulting image
  /// [maxHeight] is the maximum height of the resulting image
  /// [format] is the target format for the compressed image
  ///
  /// Returns a File containing the compressed image
  static Future<File> compressFile({
    required File file,
    int quality = 85,
    int maxWidth = 1080,
    int maxHeight = 1080,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    // Generate a temporary path using the file's path
    final originalPath = file.absolute.path;
    final lastIndex = originalPath.lastIndexOf('.');
    final targetPath = '${originalPath.substring(0, lastIndex)}_compressed${_getExtension(format)}';
    
    final result = await FlutterImageCompress.compressAndGetFile(
      originalPath,
      targetPath,
      quality: quality,
      minWidth: maxWidth,
      minHeight: maxHeight,
      format: format,
    );
    
    if (result == null) {
      throw Exception('Failed to compress image');
    }
    
    return File(result.path);
  }
  
  /// Compress an image from bytes
  ///
  /// [bytes] is the image data to compress
  /// [quality] is the compression quality (0-100)
  /// [maxWidth] is the maximum width of the resulting image
  /// [maxHeight] is the maximum height of the resulting image
  /// [format] is the target format for the compressed image
  ///
  /// Returns a Uint8List containing the compressed image data
  static Future<Uint8List> compressBytes({
    required Uint8List bytes,
    int quality = 85,
    int maxWidth = 1080,
    int maxHeight = 1080,
    CompressFormat format = CompressFormat.jpeg,
  }) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: quality,
      minWidth: maxWidth,
      minHeight: maxHeight,
      format: format,
    );
    
    return result;
  }
  
  /// Calculate the image compression ratio
  ///
  /// [originalSize] is the size of the original image in bytes
  /// [compressedSize] is the size of the compressed image in bytes
  ///
  /// Returns the compression ratio as a percentage
  static double calculateCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0;
    return ((originalSize - compressedSize) / originalSize) * 100;
  }
  
  /// Get file extension for the given compression format
  static String _getExtension(CompressFormat format) {
    switch (format) {
      case CompressFormat.jpeg:
        return '.jpg';
      case CompressFormat.png:
        return '.png';
      case CompressFormat.webp:
        return '.webp';
      case CompressFormat.heic:
        return '.heic';
      default:
        return '.jpg';
    }
  }
}