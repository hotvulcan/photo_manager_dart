import 'dart:io';

import 'package:exif/exif.dart';

main(){
  File file = new File("example.jpg");
  printExifOf(file).then((exif) {
    // print(exif.toString());
  });

  
}

Future<Map<String, String>> printExifOf(File file) async {

  Map<String, IfdTag> data = await readExifFromBytes(await file.readAsBytes());
  Map<String, String> ret = {};
  data.forEach((key, value) { ret[key] = value.toString(); });
  
  ret.forEach((key, value) {print(key);});
  return ret;
  // if (data == null || data.isEmpty) {
  //   print("No EXIF information found\n");
  //   return;
  // }

  // if (data.containsKey('JPEGThumbnail')) {
  //   print('File has JPEG thumbnail');
  //   data.remove('JPEGThumbnail');
  // }
  // if (data.containsKey('TIFFThumbnail')) {
  //   print('File has TIFF thumbnail');
  //   data.remove('TIFFThumbnail');
  // }
  
}