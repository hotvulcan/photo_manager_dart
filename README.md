# photo_manager
a dart play ground. 

我决定开始学习 Dart/Flutter。 这个 playground 记录学习过程。 

既然是图片管理，需要读取 exif 资料，找到官方的 exif 库。 
https://pub.dev/packages/exif

包管理？
https://medium.com/flutter-community/deep-dive-into-the-pubspec-yaml-file-fb56ac8683b9


pubspec.yaml has no lower-bound SDK constraint.
You should edit pubspec.yaml to contain an SDK constraint:

environment:
  sdk: '>=2.10.0 <3.0.0'

See https://dart.dev/go/sdk-constraint

Future 把我搞晕了。 

昨天太累睡着了。 早饭前再看看。 

是时候做些设计了。
作为playground，假设有海量的本地的图片，不能用普通的工具。 处理一遍可能要好多天，要有办法在程序结束后继续，不需要重来。内存占有不能增长，随时释放。 
功能要有：1.文件排重。 2. 媒体文件信息入数据库，因为处理假设中的海量文件涉及的工作数据库系统已经实现了。 3. 图形界面在 flutter 的playground做，这次不做。

我的主要想法是扫描文件系统中的图片视频，取得 exif 信息，文件尺寸、各项时间信息、再在魔法偏移量上取几个字节当特征。 信息入数据库后进行排重，发现重复的文件对文件做全 hash 并比较 hash 进行排重，删除重复的文件。 存留版的媒体文件 hash 信息入数据库留用。

不马上做全 hash 是因为速度太慢，拿到疑似重复后再做效率高很多。 不直接比较文件是因为我对这些 hash 有兴趣，以后可以玩。

早饭和咖啡，吃面包。 

在出门前再看看。

看了 Future 到用法。 改起来。 

1. 现在在函数里面打开文件，取得其它信息需要打开两次。 改。

Map 是怎么用的？
https://www.tutorialspoint.com/dart_programming/dart_programming_map.htm

async 函数要求返回 Future 
Functions marked 'async' must have a return type assignable to 'Future'.
Try fixing the return type of the function, or removing the modifier 'async' from the function 

Receiver: null ... Future 还没来。 继续学习 Future

文件列表不应该在 dart 里面做。 做到最牛也无非是本系统的 find 的效果，不如用 find 靠谱。 
所以文件列表在外部读一个文件即可。 

继续学习

