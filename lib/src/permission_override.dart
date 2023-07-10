import 'dart:async';

import 'package:access_control/access_control.dart';
import 'package:flutter/widgets.dart';

import 'feature_override_scope.dart';

abstract class PermissionOverride<T> extends Permission {
  final T feature;

  PermissionOverride(this.feature);

  @override
  FutureOr<bool> request(BuildContext context) async {
    onFallback() => fallback(context);
    final state = await FeatureOverrideScope.of<T>(context).state(feature);

    if (state.isOverride) {
      return state.value!;
    } else {
      return onFallback();
    }
  }

  FutureOr<bool> fallback(BuildContext context);
}
