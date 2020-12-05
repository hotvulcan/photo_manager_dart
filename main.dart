import 'dart:io';
import 'package:exif/exif.dart';

main(List<String> args) {
  args.forEach((fileName) {
      File file = new File(fileName);
      if(file.existsSync()){
        getImageInfo(file).then((exif) {
          print(exif.toString());
        });
      }
  });
}
Future<Map<String, String>> getImageInfo(File file) async {
  Map<String, IfdTag> data = await readExifFromBytes(await file.readAsBytes());
  
  Map<String, String> ret = {};
  data.forEach((key, value) { ret[key] = value.toString(); });
  return ret;
}