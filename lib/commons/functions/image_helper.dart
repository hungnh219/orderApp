import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class ImageHelper {
  Future<String> uploadImageToFirebase(String assetPath) async {
    try {
      ByteData byteData = await rootBundle.load(assetPath);

      Uint8List imageBytes = byteData.buffer.asUint8List();

      String base64Image = base64Encode(imageBytes);
      return base64Image;
    } catch(e) {
      return '';
    }
  }

  Future<Uint8List> getImageFromFirebase(String base64Image) async {
    try {
      Uint8List imageBytes = base64Decode(base64Image);
      return imageBytes;
    } catch(e) {
      return Uint8List(0);
    }
  }
}

