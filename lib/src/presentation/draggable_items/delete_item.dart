import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stories_editor/src/domain/models/editable_items.dart';
import 'package:stories_editor/src/presentation/utils/constants/app_enums.dart';

class DeleteItem extends StatelessWidget {
  const DeleteItem({
    Key? key,
    required EditableItem? activeItem,
    required this.isDeletePosition,
    required this.animationsDuration,
  })  : _activeItem = activeItem,
        super(key: key);

  final EditableItem? _activeItem;
  final bool isDeletePosition;
  final Duration animationsDuration;

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();

    return Visibility(
      visible: _activeItem != null && _activeItem!.type != ItemType.image,
      child: Positioned(
          bottom: 130,
          child: SizedBox(
            width: screenUtil.screenWidth,
            child: Center(
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: animationsDuration,
                height: isDeletePosition ? 55.0 : 45,
                width: isDeletePosition ? 55.0 : 45,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const ImageIcon(
                  AssetImage('assets/icons/trash.png',
                      package: 'stories_editor'),
                  color: Colors.white,
                  size: 23,
                ),
              ),
            ),
          )),
    );
  }
}
