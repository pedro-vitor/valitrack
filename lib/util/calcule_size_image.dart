import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

class CalculeSizeImage {
  static Size _calculateSizeImage(File image) {
    final sizeResult = ImageSizeGetter.getSizeResult(FileInput(image));
    return sizeResult.size;
  }

  static double getWidthImage(File image) {
    return _calculateSizeImage(image).width.toDouble();
  }

  static double getHeightImage(File image) {
    return _calculateSizeImage(image).height.toDouble();
  }
}
