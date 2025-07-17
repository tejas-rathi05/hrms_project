import 'dart:io';

class ImageSize {
   int? imageWidth;
   int? imageHeight;
  List<File> _files = [];

  int get image_width {
    return imageWidth!;
  }

  void set image_width(int imageWidth) {
    this.imageWidth = imageWidth;
  }
}
