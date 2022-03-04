import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stories_editor/src/domain/providers/photo_provider.dart';
import 'package:stories_editor/src/presentation/gallery/widgets/dropdown.dart';

class SelectedPathDropdownButton extends StatelessWidget {
  final PickerDataProvider provider;
  final GlobalKey? dropdownRelativeKey;

  const SelectedPathDropdownButton({
    Key? key,
    required this.provider,
    this.dropdownRelativeKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arrowDownNotifier = ValueNotifier(false);
    return AnimatedBuilder(
      animation: provider.currentPathNotifier,
      builder: (_, __) => DropDown<AssetPathEntity>(
        relativeKey: dropdownRelativeKey!,
        child: ((context) => buildButton(context, arrowDownNotifier))(context),
        dropdownWidgetBuilder: (BuildContext context, close) {
          return ChangePathWidget(
            provider: provider,
            close: close,
          );
        },
        onResult: (AssetPathEntity? value) {
          if (value != null) {
            provider.currentPath = value;
          }
        },
        onShow: (value) {
          arrowDownNotifier.value = value;
        },
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    ValueNotifier<bool> arrowDownNotifier,
  ) {
    if (provider.pathList.isEmpty || provider.currentPath == null) {
      return Container();
    }

    final decoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(35),
    );
    if (provider.currentPath == null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: decoration,
      );
    } else {
      return Container(
        //padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: decoration,
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                child: Text(
                  provider.currentPath!.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: AnimatedBuilder(
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFB2B2B2),
                  ),
                  animation: arrowDownNotifier,
                  builder: (BuildContext context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class ChangePathWidget extends StatefulWidget {
  final PickerDataProvider provider;
  final ValueSetter<AssetPathEntity> close;

  const ChangePathWidget({
    Key? key,
    required this.provider,
    required this.close,
  }) : super(key: key);

  @override
  _ChangePathWidgetState createState() => _ChangePathWidgetState();
}

class _ChangePathWidgetState extends State<ChangePathWidget> {
  PickerDataProvider get provider => widget.provider;

  ScrollController? controller;
  double itemHeight = 65;

  @override
  void initState() {
    super.initState();
    final index = provider.pathList.indexOf(provider.currentPath!);
    controller = ScrollController(initialScrollOffset: itemHeight * index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView.builder(
          controller: controller,
          itemCount: provider.pathList.length,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final item = provider.pathList[index];
    Widget w = SizedBox(
      height: 65.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
    w = Stack(
      children: <Widget>[
        /// list of album
        w,

        /// divider
        Positioned(
          height: 1,
          bottom: 0,
          right: 0,
          left: 1,
          child: IgnorePointer(
            child: Container(
              color: const Color(0xFF484848),
            ),
          ),
        ),
      ],
    );
    return GestureDetector(
      child: w,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        widget.close.call(item);
      },
    );
  }
}
