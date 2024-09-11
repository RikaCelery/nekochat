import 'dart:io';
import 'dart:typed_data';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List?> cacheImage(String name, String dir, String ext, Future<Uint8List> Function() download) async {
  if (PlatformInfos.isAndroid) {
    final folder = await getDownloadsDirectory();
    final tmpFile = File("${folder?.path}${dir.isNotEmpty?"/$dir":""}/${Uri.encodeComponent(name)}.$ext");
    if (!await tmpFile.parent.exists()){
      await tmpFile.parent.create(recursive: true);
    }
    if (!await tmpFile.exists()) {
      print("cache ${tmpFile.path}");
      try {
        await tmpFile.writeAsBytes(await download());
      } catch (e) {
        print(e);
        return null;
      }
    }else{
      print("cached ${tmpFile.path}");
      return await tmpFile.readAsBytes();
    }
  }
  throw Exception("Not implemented");
}
