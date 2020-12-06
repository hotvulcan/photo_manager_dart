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

早饭喝咖啡，吃面包。 

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

https://stackoverflow.com/questions/9279541/how-do-i-access-argv-command-line-options-in-dart 
命令行怎么用？

格式化字符串用啥？
https://pub.dev/packages/sprintf
不过还是用字符串嵌入吧。。。

会给变量起名字，会使用日期函数，等于学会了嘛。

文件 hash 怎么拿？
https://pub.dev/packages/crypto

发现 exif 这个库不能拿到视频的metadata，以后再说。

避免重复处理有两个办法，一个是记录当前处理到文件的偏移量，下次重新启动软件的时候从这个偏移量开始。 另一个是记录完成了的文件名，每次启动都从原始文件中刨除完成了的文件，生成任务文件。 当然要先核对原始文件和任务文件的版本，没动过就不用生成。 这样在实际工作中会很方便，因为原始文件总要改的，人类不可靠。。。。  这个部分用个脚本写更容易一些。 大体伪代码如下：
perl -e ”$hash = sha1 all.txt ; if( $hash ne head -1 jobs.txt) {`echo $hash > jobs.txt && cat all.txt done.txt“ | sort | uniq -c | awk -F“ ” '/^1 /' '{$1="";print}' >> jobs.txt && dart main.dart `} else {`dart main.dart`}

为了玩dart，我用第一种。


遇到问题了，我不知道怎么挨行读一个大型文件。 用readlines 之类读都是一股脑读进内存。 我这样有上百万个文件名（行）的，很容易就把内存撑爆了。 网上资料看上去又都很可疑，怎么会这么笨？


