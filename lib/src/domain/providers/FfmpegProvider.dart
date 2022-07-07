// ignore_for_file: file_names

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stories_editor/src/presentation/utils/constants/directory_path.dart';
import 'package:stories_editor/src/presentation/utils/constants/render_type.dart';

class FfmpegProvider with ChangeNotifier {
  bool loading = false, isPlaying = false;

  Future<Map<String, dynamic>> mergeIntoVideo(
      {required RenderType renderType}) async {
    loading = true;
    notifyListeners();

    if (await Permission.storage.request().isGranted) {
      var tempDir = await getTemporaryDirectory();
      var tempDirPath = tempDir.path;
      var dir = '$tempDirPath/stories_editor';

      /// mp4 output
      String mp4Command =
          '-r 25 -i $dir/%0d.png -vf scale=720:1280 -pix_fmt yuv420p -y $dir/output.mp4';

      /// 7mb gif output
      String gifCommand =
          '-r 25 -i $dir/%0d.png -vf "scale=iw/2:ih/2" -y $dir/output.mp4';

      var response = await FFmpegKit.execute(
              renderType == RenderType.gif ? gifCommand : mp4Command)
          .then((rc) async {
        loading = false;
        notifyListeners();
        debugPrint(
            'FFmpeg process exited with rc ==> ${await rc.getReturnCode()}');
        debugPrint('FFmpeg process exited with rc ==> ${rc.getCommand()}');
        var res = await rc.getReturnCode();

        if (res!.getValue() == 0) {
          return {
            'success': true,
            'msg': 'Widget was render successfully.',
            'outPath': renderType == RenderType.gif
                ? '$dir/output.gif'
                : '$dir/output.mp4'
          };
        } else if (res.getValue() == 1) {
          return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
        } else {
          return {'success': false, 'msg': 'Widget was render unsuccessfully.'};
        }
      });

      return response;
    } else if (await Permission.storage.isPermanentlyDenied) {
      loading = false;
      notifyListeners();
      openAppSettings();
      return {'success': false, 'msg': 'Missing storage permission.'};
    } else {
      return {'success': false, 'msg': 'unknown error.'};
    }
  }
}
