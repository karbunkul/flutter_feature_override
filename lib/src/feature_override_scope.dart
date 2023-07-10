import 'package:feature_override/src/feature_state.dart';
import 'package:flutter/widgets.dart';

typedef OverrideCallback = void Function(String key, bool value);
typedef FeatureStateCallback<T> = Future<FeatureState> Function(T feature);
typedef RemoveOverrideCallback = void Function(String key);

class FeatureOverrideScope<T> extends InheritedWidget {
  final FeatureStateCallback<T> state;
  final OverrideCallback update;
  final RemoveOverrideCallback remove;

  const FeatureOverrideScope({
    super.key,
    required this.state,
    required this.update,
    required this.remove,
    required Widget child,
  }) : super(child: child);

  static FeatureOverrideScope<T> of<T>(BuildContext context) {
    final FeatureOverrideScope<T>? result =
        context.dependOnInheritedWidgetOfExactType<FeatureOverrideScope<T>>();
    assert(result != null, 'No FeatureOverrideScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FeatureOverrideScope oldWidget) {
    return false;
  }
}
