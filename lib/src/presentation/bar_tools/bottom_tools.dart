import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'dart:html' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:stories_editor/src/domain/sevices/save_as_image.dart';
import 'package:stories_editor/src/presentation/widgets/animated_onTap_button.dart';
import 'package:image_picker_web/image_picker_web.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(dynamic imageUri) onDone;
  final Function(Uint8List bytes)? selectImageWeb;
  final Widget? onDoneButtonStyle;

  /// editor background color
  final Color? editorBackgroundColor;

  const BottomTools({
    Key? key,
    required this.contentKey,
    required this.onDone,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
    this.selectImageWeb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier, __) {
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// save final image to gallery
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.9,
                      child: AnimatedOnTapButton(
                          onTap: () async {
                            // String pngUri;
                            await takePicture(contentKey: contentKey, context: context, saveToGallery: false)
                                .then((bytes) {
                              if (bytes != null) {
                                // pngUri = bytes;
                                onDone(bytes);
                              } else {}
                            });
                          },
                          child: onDoneButtonStyle ??
                              Container(
                                padding: const EdgeInsets.only(left: 12, right: 5, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.white, width: 1.5)),
                                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ]),
                              )),
                    ),
                  ),
                ),

                /// center logo
                if (controlNotifier.middleBottomWidget != null)
                  Expanded(
                    child: Center(
                      child: Container(alignment: Alignment.bottomCenter, child: controlNotifier.middleBottomWidget),
                    ),
                  ),

                /// preview gallery
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: _preViewContainer(
                        /// if [model.imagePath] is null/empty return preview image
                        child: controlNotifier.mediaPath.isEmpty && controlNotifier.mediaByte.isEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (kIsWeb) {
                                      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
                                      if (bytesFromPicker != null) {
                                        selectImageWeb!.call(bytesFromPicker);
                                      }
                                      return;
                                    }

                                    /// scroll to gridView page
                                    if (controlNotifier.mediaPath.isEmpty) {
                                      scrollNotifier.pageController.animateToPage(1,
                                          duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                    }
                                  },
                                  child: kIsWeb
                                      ? const Icon(CupertinoIcons.photo, color: Colors.white)
                                      : const CoverThumbnail(
                                          thumbnailQuality: 150,
                                        ),
                                ))

                            /// return clear [imagePath] provider
                            : GestureDetector(
                                onTap: () {
                                  /// clear image url variable
                                  controlNotifier.mediaPath = '';
                                  controlNotifier.mediaByte = Uint8List.fromList([]);
                                  itemNotifier.draggableWidget.removeAt(0);
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
