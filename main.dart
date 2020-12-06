import 'dart:io';
import 'package:exif/exif.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method

const int MinFileSize =  1024*15; // 15k 以下的图片直接算 hash，更大的图片hash字段先空着。
const int SamplePosition1 = 1024*10;
const int SamplePosition2 = 1024*12;

main(List<String> args) {
  args.forEach((fileName) { // 目前是在命令行获取参数中的文件名的，我要的是在一个文件清单中获取文件名，改。
      File file = new File(fileName);
      if(file.existsSync()){
        if (file.statSync().size > MinFileSize){
          getImageInfo(file).then((exif) {
            print(exif.toString());
          });
        }else{

        }
        
      }else{
        // todo, no such file;
        ;
      }
  });
}


Future<Map<String, String>> getImageInfo(File file) async {
  Map<String, String> ret = {};
  
  var containts = await file.readAsBytes();
  String hash;
  var fileStat = file.statSync();
  ret['size']     = fileStat.size.toString();
  if( fileStat.size < MinFileSize ){
    ret['hash']     = sha1.convert(containts) as String;
    return ret;
  } // else:
  
  var samples  = containts.sublist(SamplePosition1,SamplePosition1+2) 
               + containts.sublist(SamplePosition2,SamplePosition2+2);
  ret['hash']     = hash;
  ret['samples']  = samples.join('');
  ret['changed']  = fileStat.changed.toIso8601String();
  ret['modified'] = fileStat.modified.toIso8601String();
  Map<String, IfdTag> exifMap = await readExifFromBytes(containts);
  exifMap.forEach((key, value) { ret[key] = value.toString(); });
  return ret;
}