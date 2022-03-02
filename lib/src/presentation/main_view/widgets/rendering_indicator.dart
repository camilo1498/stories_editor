import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/rendering_notifier.dart';
import 'package:stories_editor/src/presentation/utils/constants/render_state.dart';

class RenderingIndicator extends StatelessWidget {
  const RenderingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<ControlNotifier, RenderingNotifier>(
        builder: (_, controlNotifier, renderingNotifier, __) {
      if (renderingNotifier.renderState != RenderState.none) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      renderingNotifier.renderState.name == 'frames'
                          ? renderingNotifier.renderState.name +
                              ' ' +
                              renderingNotifier.totalFrames.toString()
                          : renderingNotifier.renderState.name == 'preparing'
                              ? renderingNotifier.renderState.name +
                                  ' ' +
                                  renderingNotifier.currentFrames.toString() +
                                  '/' +
                                  renderingNotifier.totalFrames.toString()
                              : renderingNotifier.renderState.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
