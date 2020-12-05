import 'dart:io';
import 'package:exif/exif.dart';
const int MinFileSize =  1024*15; // 15k 以下的图片就不管了。
const int SamplePosition1 = 1024*10;
const int SamplePosition2 = 1024*12;

main(List<String> args) {
  args.forEach((fileName) {
      File file = new File(fileName);
      if(file.existsSync()){
        getImageInfo(file).then((exif) {
          print(exif.toString());
        });
      }else{
        // todo, no such file;
        ;
      }
  });
}
Future<Map<String, String>> getImageInfo(File file) async {
  var containts = await file.readAsBytes();
  Map<String, IfdTag> exifMap = await readExifFromBytes(containts);

  Map<String, String> ret = {};
  var fileStat = file.statSync();
  var samples  = containts.sublist(SamplePosition1,SamplePosition1+2) 
               + containts.sublist(SamplePosition2,SamplePosition2+2);

  ret["samples"]  = samples.join("");
  ret['size']     = fileStat.size.toString();
  ret['changed']  = fileStat.changed.toIso8601String();
  ret['modified'] = fileStat.modified.toIso8601String();
  
  exifMap.forEach((key, value) { ret[key] = value.toString(); });
  return ret;
}