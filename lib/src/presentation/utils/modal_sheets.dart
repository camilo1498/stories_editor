import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
import 'package:stories_editor/src/presentation/utils/Extensions/hexColor.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';

/// create item of type GIF
Future createGiphyItem(
    {required BuildContext context, required giphyKey}) async {
  final _editableItem =
      Provider.of<DraggableWidgetNotifier>(context, listen: false);
  _editableItem.giphy = await ModalGifPicker.pickModalSheetGif(
    context: context,
    apiKey: giphyKey,
    rating: GiphyRating.r,
    sticker: true,
    backDropColor: Colors.black,
    crossAxisCount: 3,
    childAspectRatio: 1.2,
    topDragColor: Colors.white.withOpacity(0.2),
  );

  /// create item of type GIF
  if (_editableItem.giphy != null) {
    _editableItem.draggableWidget.add(EditableItem()
      ..type = ItemType.gif
      ..gif = _editableItem.giphy!
      ..position = const Offset(0.0, 0.0));
  }
}

/// custom exit dialog
Future<bool> exitDialog({required context, required contentKey, required bool isRtl}) async {
  return (await showDialog(
        context: context,
        barrierColor: Colors.black38,
        barrierDismissible: true,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetAnimationDuration: const Duration(milliseconds: 300),
          insetAnimationCurve: Curves.ease,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.only(top: 25, bottom: 5, right: 10, left: 10),
              alignment: Alignment.center,
              height: 320,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white10,
                        offset: Offset(0, 1),
                        blurRadius: 4),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    isRtl ? 'حذف تغییرات' :'Discard Edits?',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.5),
                  ),
                  20.verticalSpace,
                  Text(
                    isRtl ? "اگر به عقب برگردید، تمام ویرایش هایی را که انجام داده اید از دست خواهید داد" :
                    "If you go back now, you'll lose all the edits you've made.",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        letterSpacing: 0.1),
                    textAlign: TextAlign.center,
                  ),

                  20.verticalSpace,
                  /// discard
                  AnimatedOnTapButton(
                    onTap: () async {
                      _resetDefaults(context: context);
                      Navigator.of(context).pop(true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRtl ? "دورانداختن" : 'Discard',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent.shade200,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),

                  /// save and exit
                  AnimatedOnTapButton(
                    onTap: () async {
                      final _paintingProvider =
                          Provider.of<PaintingNotifier>(context, listen: false);
                      final _widgetProvider =
                          Provider.of<DraggableWidgetNotifier>(context,
                              listen: false);
                      if (_paintingProvider.lines.isNotEmpty ||
                          _widgetProvider.draggableWidget.isNotEmpty) {
                        /// save image
                        var response = await takePicture(
                            contentKey: contentKey,
                            context: context,
                            saveToGallery: true);
                        if (response) {
                          _dispose(
                              context: context, message: isRtl ? "باموفقیت ذخیره شد" : 'Successfully saved');
                        } else {
                          _dispose(context: context, message: isRtl ? "خطا" : 'Error');
                        }
                      } else {
                        _dispose(context: context, message: isRtl ? "تغییراتی انجام نداده‌اید" : 'Draft Empty');
                      }
                    },
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRtl ? "ذخیره پیش‌نویس" : 'Save Draft',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),

                  ///cancel
                  AnimatedOnTapButton(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isRtl ? "لغو" : 'Cancel',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )) ??
      false;
}

_resetDefaults({required BuildContext context}) {
  final _paintingProvider =
      Provider.of<PaintingNotifier>(context, listen: false);
  final _widgetProvider =
      Provider.of<DraggableWidgetNotifier>(context, listen: false);
  final _controlProvider = Provider.of<ControlNotifier>(context, listen: false);
  final _editingProvider =
      Provider.of<TextEditingNotifier>(context, listen: false);
  _paintingProvider.lines.clear();
  _widgetProvider.draggableWidget.clear();
  _widgetProvider.setDefaults();
  _paintingProvider.resetDefaults();
  _editingProvider.setDefaults();
  _controlProvider.mediaPath = '';
}

_dispose({required context, required message}) {
  _resetDefaults(context: context);
  Fluttertoast.showToast(msg: message);
  Navigator.of(context).pop(true);
}
