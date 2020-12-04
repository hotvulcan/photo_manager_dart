import “exif“;
main(){
  print("good");
}

printExifOf(String path) async {

  Map<String, IfdTag> data = readExifFromBytes(await new File(path).readAsBytes());

  if (data == null || data.isEmpty) {
    print("No EXIF information found\n");
    return;
  }

  if (data.containsKey('JPEGThumbnail')) {
    print('File has JPEG thumbnail');
    data.remove('JPEGThumbnail');
  }
  if (data.containsKey('TIFFThumbnail')) {
    print('File has TIFF thumbnail');
    data.remove('TIFFThumbnail');
  }

  for (String key in data.keys) {
    print("$key (${data[key].tagType}): ${data[key]}");
  }
  
}