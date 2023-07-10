import 'dart:async';

import 'package:feature_override/src/feature_override_scope.dart';
import 'package:feature_override/src/feature_state.dart';
import 'package:feature_override/src/state_storage.dart';
import 'package:flutter/widgets.dart';

typedef ConvertCallback<T> = String Function(T value);

class FeatureOverride<T> extends StatefulWidget {
  final ConvertCallback<T> onConvert;
  final StateStorage? storage;
  final Widget child;

  const FeatureOverride({
    super.key,
    required this.onConvert,
    this.storage,
    required this.child,
  });

  @override
  State<FeatureOverride<T>> createState() => _FeatureOverrideState<T>();
}

class _FeatureOverrideState<T> extends State<FeatureOverride<T>> {
  late final StateStorage _storage;

  @override
  void initState() {
    _storage = widget.storage ?? _Storage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureOverrideScope<T>(
      state: _state,
      remove: _remove,
      update: _update,
      child: widget.child,
    );
  }

  void _remove(String key) => _storage.remove(key);

  void _update(String key, bool value) => _storage.update(key, value);

  Future<FeatureState> _state(T feature) async {
    final key = widget.onConvert(feature);

    return FeatureState(
      key: key,
      value: await _storage.read(key),
    );
  }
}

class _Storage extends StateStorage {
  final _data = <String, bool>{};

  @override
  FutureOr<bool?> read(String key) => _data[key];

  @override
  FutureOr<void> remove(String key) => _data.remove(key);

  @override
  FutureOr<void> update(String key, bool value) => _data[key] = value;
}
