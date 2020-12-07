import 'dart:io';
import 'package:exif/exif.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // for the utf8.encode method
import 'dart:async';

const int MinFileSize = 1024 * 15; // 15k 以下的图片直接算 hash，更大的图片hash字段先空着。
const int SamplePosition1 = 1024 * 10;
const int SamplePosition2 = 1024 * 12;
const String JobFile = "Jobs.txt";
const String LastJobFile = "last_job.txt";
test() {
  final file = new File('jobs.txt');
  Stream<List<int>> inputStream = file.openRead();

  int skipLines = int.parse(File(LastJobFile).readAsStringSync());
  int currentLine = skipLines;
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(new LineSplitter()) // Convert stream to individual lines.
      .skip(skipLines)
      .listen((String mediaFileName) {
    // Process results.
    currentLine += 1;
    print('$JobFile:$currentLine> $mediaFileName');
    File mediaFile = new File(mediaFileName);
    if (mediaFile.existsSync()) {
      getImageInfo(mediaFile, mediaFileName).then((mediaInfo) {
        print(mediaInfo.values.map((e) => e.toString().replaceAll("\t", "    ")).join("\t"));
      });
    } else {
      // todo, no such file;
    }
    File(LastJobFile).writeAsStringSync(currentLine.toString(), flush: true);
  }, onDone: () {
    ;
  }, onError: (err) {
    print(err.toString());
    exit(0);
  });
}

int main() {
  test();
  return 0;
}

Future<Map<String, String>> getImageInfo(File file, String fileName) async {
  Map<String, String> ret = {};

  var containts = await file.readAsBytes();
  String hash;
  var fileStat = file.statSync();
  ret['size'] = fileStat.size.toString();
  if (fileStat.size < MinFileSize) {
    ret['samples'] =
        containts.length > 4 ? containts.sublist(0, 4).join('') : "00000000";
    ret['hash'] = sha1.convert(containts).toString();
    ret['changed'] = fileStat.changed.toIso8601String();
    ret['modified'] = fileStat.modified.toIso8601String();
    ret['file_name'] = fileName;
    ret['exif'] = 'NULL';
    return ret;
  } // else:

  var samples = containts.sublist(SamplePosition1, SamplePosition1 + 2) +
      containts.sublist(SamplePosition2, SamplePosition2 + 2);
  ret['samples'] = samples.join('');
  ret['hash'] = hash;
  ret['changed'] = fileStat.changed.toIso8601String();
  ret['modified'] = fileStat.modified.toIso8601String();
  ret['file_name'] = fileName;
  List<String> exif = [];
  try{
    Map<String,IfdTag> exifMap = await readExifFromBytes(containts);
    exifMap.forEach((key, value) {
      exif.add("'$key':'${value.toString()}'");
    });
    String exifJson = "{${exif.join(',')}}";
    ret['exif'] = exifJson;
  }catch(e){
    ret['exif'] = 'NULL';
    stderr.writeln("Got error: ${e.toString()} with $fileName");
  }
  
  return ret;
}
