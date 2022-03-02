// ignore_for_file: file_names

import 'package:ffmpeg_kit_flutter_min_gpl/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
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
      /// mp4 output
      String mp4Command =
          '-r 30 -i ${FfmpegPaths.imagesPath} -vf scale=1080:1920 -pix_fmt yuv420p -y ${FfmpegPaths.videoOutputPath}';

      /// 7mb gif output
      String gifCommand =
          '-r 30 -i ${FfmpegPaths.imagesPath} -vf "scale=iw/2:ih/2" -y ${FfmpegPaths.gifOutputPath}';

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
                ? FfmpegPaths.gifOutputPath
                : FfmpegPaths.videoOutputPath
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
