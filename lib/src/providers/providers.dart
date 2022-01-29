export 'package:stories_editor/src/providers/providers.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:stories_editor/src/providers/control_variable_provider.dart';
import 'package:stories_editor/src/providers/custom_scrollController_provider.dart';
import 'package:stories_editor/src/providers/draggable_widget_provider.dart';
import 'package:stories_editor/src/providers/gradientProvider.dart';
import 'package:stories_editor/src/providers/painting_provider.dart';
import 'package:stories_editor/src/providers/photo_provider.dart';
import 'package:stories_editor/src/providers/text_editing_provider.dart';

/// is required put the providers here and call in your runApp
/// runApp(
///    MultiProvider(
///       providers: storiesEditorProviders,
///       child: const MyApp(),
///     )
///   )

class StoriesEditorProvider{
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => TextEditorProvider()),
    ChangeNotifierProvider(create: (_) => PaintingProvider()),
    ChangeNotifierProvider(create: (_) => CustomScrollControllerProvider()),
    ChangeNotifierProvider(create: (_) => PickerDataProvider()),
    ChangeNotifierProvider(create: (_) => DraggableWidgetProvider()),
    ChangeNotifierProvider(create: (_) => GradientProvider()),
    ChangeNotifierProvider(create: (_) => ControlVariableProvider()),
  ];
}

