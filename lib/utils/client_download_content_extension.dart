import 'dart:io';
import 'dart:typed_data';

import 'package:fluffychat/utils/file_cache.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

extension ClientDownloadContentExtension on Client {
  Future<Uint8List> downloadMxcCached(
    Uri mxc, {
    num? width,
    num? height,
    bool isThumbnail = false,
    bool? animated,
    ThumbnailMethod? thumbnailMethod,
  }) async {
    // To stay compatible with previous storeKeys:
    final cacheKey = isThumbnail
        // ignore: deprecated_member_use
        ? mxc.getThumbnail(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod!,
          )
        : mxc;
    print("mxc cacheKey: $cacheKey, file cache");
    if (PlatformInfos.isAndroid) {
      final folder = await getDownloadsDirectory();
      final tmpFile = File(
          "${folder?.path}/${Uri.encodeComponent(cacheKey.pathSegments.last)}");
      if (await tmpFile.exists()) return await tmpFile.readAsBytes();
    }

    // if (isThumbnail) {
    //   final cachedData = await database?.getFile(cacheKey);
    //   if (cachedData != null) return cachedData;
    // }

    final httpUri = isThumbnail
        ? await mxc.getThumbnailUri(
            this,
            width: width,
            height: height,
            animated: animated,
            method: thumbnailMethod,
          )
        : await mxc.getDownloadUri(this);
    print("mxc http: ${isThumbnail ? 'thumb' : 'ori'} $httpUri $mxc");

    final remoteData = await cacheImage(cacheKey.pathSegments.last, isThumbnail ? 'thumb_image' : 'ori_image',"png", () async {
      final response = await httpClient.get(
        httpUri,
        headers: accessToken == null
            ? null
            : {'authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
      return response.bodyBytes;
    });
    if (remoteData == null) throw Exception();
    // if (isThumbnail) await database?.storeFile(cacheKey, remoteData, 100);

    return remoteData;
  }
}
