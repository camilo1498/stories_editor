import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/services/save_as_image.dart';
import 'package:stories_editor/src/utils/animated_onTap_button.dart';
import 'package:stories_editor/src/utils/modal_sheets/modal_sheets.dart';
import 'package:stories_editor/src/widgets/common_widgets/tool_button.dart';

class TopTools extends StatefulWidget {
  final GlobalKey contentKey;
  const TopTools({
    Key? key,
    required this.contentKey
  }) : super(key: key);

  @override
  _TopToolsState createState() => _TopToolsState();
}

class _TopToolsState extends State<TopTools> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<ControlVariableProvider, PickerDataProvider>(
      builder: (context, controlProvider, imageProvider, child){
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
                color: Colors.transparent
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// close button
                ToolButton(
                    child: const Icon(Icons.close, color: Colors.white,),
                    backGroundColor: Colors.black12,
                    onTap: (){}
                ),
                if(imageProvider.imagePath.isEmpty)
                  _selectColor(
                      controlProvider: controlProvider,
                      onTap: (){
                        if(controlProvider.gradientIndex >= controlProvider.gradientColors!.length - 1){
                          setState(() {
                            controlProvider.gradientIndex = 0;
                          });
                        }else{
                          setState(() {
                            controlProvider.gradientIndex +=1;
                          });
                        }
                      }
                  ),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/download.png', package: 'stories_editor'),
                      color: Colors.white,size: 20,),
                    backGroundColor: Colors.black12,
                    onTap: () async{
                      final _paintingProvider = Provider.of<PaintingProvider>(context, listen: false);
                      final _widgetProvider = Provider.of<DraggableWidgetProvider>(context, listen: false);
                      if(_paintingProvider.lines.isNotEmpty || _widgetProvider.draggableWidget.isNotEmpty){
                        var response = await takePicture(
                            contentKey: widget.contentKey,
                            context: context,
                            saveToGallery: true
                        );
                        if(response){
                          Fluttertoast.showToast(msg: 'Successfully saved');
                        } else{
                          Fluttertoast.showToast(msg: 'Error');
                        }
                      }
                    }
                ),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/stickers.png', package: 'stories_editor'),
                      color: Colors.white,size: 20,),
                    backGroundColor: Colors.black12,
                    onTap: () => createGiphyItem(context: context, giphyKey: controlProvider.giphyKey)
                ),
                ToolButton(
                    child: const ImageIcon(
                      AssetImage('assets/icons/draw.png', package: 'stories_editor'),
                      color: Colors.white,size: 20,),
                    backGroundColor: Colors.black12,
                    onTap: (){
                      controlProvider.isPainting = true;
                      createLinePainting(context: context);
                    }
                ),
                ToolButton(
                  child: const ImageIcon(
                    AssetImage('assets/icons/text.png', package: 'stories_editor'),
                    color: Colors.white,size: 20,),
                  backGroundColor: Colors.black12,
                  onTap: () => createText(
                      context: context,
                      controlProvider: controlProvider
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }






  /// gradient color selector
  Widget _selectColor({onTap, controlProvider}){
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5, top: 8),
      child: AnimatedOnTapButton(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: controlProvider.gradientColors![controlProvider.gradientIndex]
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

