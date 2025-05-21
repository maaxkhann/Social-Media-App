import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Thumbnail {
  static final ins = Thumbnail._internal();
  Thumbnail._internal();

  Future<String?> generateThumbnail(String videoUrl) async {
    final tempDir = await getTemporaryDirectory();
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
    );
    return thumbnail;
  }
}
