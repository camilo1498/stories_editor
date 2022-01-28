import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/custom_scrollController_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/services/save_as_image.dart';
import 'package:stories_editor/src/utils/animated_onTap_button.dart';
import 'package:stories_editor/src/widgets/custom_image_picker/asset_path_cover_widget.dart';

class BottomTools extends StatelessWidget {
  final PickerDataProvider? provider;
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  const BottomTools({Key? key,
    required this.provider,
    required this.contentKey,
    required this.onDone
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Consumer3<PickerDataProvider, DraggableWidgetProvider, ControlVariableProvider>(
        builder: (context, imageProvider, itemProvider, controlProvider, child){
          return  Container(
            height: 95,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// preview gallery
                Container(
                    width: _size.width / 3,
                    height: _size.width / 3,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30),
                    /// if [provider] is null return a progress indicator widget
                    child: provider!.pathList.isEmpty
                        ? _preViewContainer(
                      child: Transform.scale(
                        scale: 0.4,
                        child: const CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    )
                    /// return provider container
                        : _preViewContainer(
                      /// if [model.imagePath] is null/empty return preview image
                      child: imageProvider.isEmpty ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GestureDetector(
                            onTap: (){
                              /// scroll to gridView page
                              if(imageProvider.imagePath.isEmpty){
                                Provider.of<CustomScrollControllerProvider>(context, listen: false)
                                    .pageController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease
                                );
                              }
                            },
                            child: AssetPathCoverWidget(
                              entity: provider!.pathList[0],
                              thumbSize: 120,
                            ),
                          )
                      )
                      /// return clear [imagePath] provider
                          : GestureDetector(
                        onTap: (){
                          /// clear image url variable
                          imageProvider.imagePath.clear();
                          imageProvider.isEmpty = true;
                          itemProvider.draggableWidget.removeAt(0);
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
                    )
                ),

                /// center logo
                controlProvider.middleBottomWidget != null ? Center(
                  child: Container(
                      width: _size.width / 3,
                      height: 80,
                      alignment: Alignment.bottomCenter,
                      child: controlProvider.middleBottomWidget
                  ),
                ) :
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/instagramlogo.png',
                        package: 'stories_editor',
                        color: Colors.white,
                        height: 42,
                      ),

                      const Text(
                        'Stories Creator',
                        style:  TextStyle(
                            color: Colors.white38 ,
                            letterSpacing: 1.5,
                            fontSize: 9.2,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),

                /// save final image to gallery
                Container(
                  width: _size.width / 3,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 15),
                  child: Transform.scale(
                    scale: 0.9,
                    child: AnimatedOnTapButton(
                        onTap: () async{
                          var pngUri;
                          await takePicture(contentKey: contentKey, context: context, saveToGallery: false).then((bytes) {
                            if(bytes != null){
                              pngUri = bytes;
                              onDone(pngUri);
                            } else{
                            }
                          });
                        },
                        child:  Container(
                          padding: const EdgeInsets.only(left: 12,right: 5,top: 4,bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.white,
                                  width: 1.5
                              )
                          ),
                          child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Share',
                                  style:  TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ]
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _preViewContainer({child}){
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1.4,
              color: Colors.white
          )
      ),
      child: child,
    );
  }

}
