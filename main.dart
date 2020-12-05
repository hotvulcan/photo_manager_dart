import 'dart:io';
import 'package:exif/exif.dart';

main(){
  File file = new File("example.jpg");
  getImageInfo(file).then((exif) {
    print(exif.toString());
  });

  
}

Future<Map<String, String>> getImageInfo(File file) async {
  Map<String, IfdTag> data = await readExifFromBytes(await file.readAsBytes());
  
  Map<String, String> ret = {};
  data.forEach((key, value) { ret[key] = value.toString(); });
  return ret;
}